import SwiftUI
import DecksterLib

struct CrazyEightsView: View {
    @State private var viewModel: ViewModel

    init(gameConfig: GameConfig) {
        viewModel = ViewModel(gameConfig: gameConfig)
    }

    var body: some View {
        VStack {
            CrazyEightsPlaymat(
                currentSuit: viewModel.currentSuit,
                topCard: viewModel.topCard
            )
            .frame(maxHeight: .infinity)

            HStack {
                Button("Pass turn") { viewModel.sendAction(.pass) }
                Button("Draw card") { viewModel.sendAction(.drawCard) }
            }

            Divider()
            VStack {
                Text("Your hand")
                    .bold()
                YourCardsView(
                    cards: viewModel.yourCards,
                    cardSelected: { viewModel.cardSelected($0) }
                )
                .overlay {
                    Rectangle().foregroundStyle(
                        viewModel.itIsYourTurn ? .clear : .gray.opacity(0.2)
                    )
                }
                .padding([.leading, .trailing, .top])
            }
        }
        .task {
            await viewModel.connect()
        }
    }
}

extension CrazyEightsView {
    @Observable
    class ViewModel {
        let gameConfig: GameConfig
        let client: CrazyEights.Client
        var notificationTask: Task<Void, Never>?

        var itIsYourTurn = false
        var currentSuit: Card.Suit?
        var yourCards = [Card]()
        var topCard: Card?

        init(gameConfig: GameConfig) {
            self.gameConfig = gameConfig

            client = CrazyEights.Client(
                hostname: gameConfig.userConfig.host,
                gameId: gameConfig.gameId,
                accessToken: gameConfig.userConfig.userModel.accessToken
            )
        }

        func connect() async {
            do {
                try await client.connect()

                notificationTask = Task {
                    do {
                        for try await notification in client.notificationStream {
                            handleNotification(notification)
                        }
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }

        func sendAction(_ action: CrazyEights.Action) {
            Task {
                do {
                    let response = try await client.sendAction(action)
                    handleResponse(response)
                    itIsYourTurn = false
                } catch {
                    print(error)
                }
            }
        }

        func cardSelected(_ card: Card) {
            if card.rank == 8 {
                sendAction(.putEight(card: card, newSuit: .diamonds))
            } else {
                sendAction(.putCard(card: card))
            }
        }

        private func handleNotification(_ notification: CrazyEights.Notification) {
            switch notification {
            case .gameEnded(let players):
                break
            case .gameStarted(let _, let viewOfGame):
                setGameView(viewOfGame)
            case .itsYourTurn(let viewOfGame):
                itIsYourTurn = true
                setGameView(viewOfGame)
            case .playerDrewCard(let playerId):
                break
            case .playerIsDone(let playerId):
                break
            case .playerPassed(let playerId):
                break
            case .playerPutCard(let playerId, let card):
                topCard = card
            case .playerPutEight(let playerId, let card, let newSuit):
                currentSuit = newSuit
                topCard = card
            }
        }

        private func handleResponse(_ actionResponse: CrazyEights.ActionResponse) {
            switch actionResponse {
            case .empty:
                break
            case .card(let card):
                yourCards.append(card)
            case .viewOfGame(let gameView):
                setGameView(gameView)
            case .error(let string):
                print(string)
            }
        }

        private func setGameView(_ gameView: CrazyEights.GameView) {
            currentSuit = gameView.currentSuit
            topCard = gameView.topOfPile
            yourCards = gameView.cards
        }
    }
}

#Preview {
    CrazyEightsView(
        gameConfig: GameConfig(
            game: .chatroom,
            gameId: "pønskende konge",
            userConfig: UserConfig(
                host: "localhost:13992",
                userModel: UserModel(
                    id: "1234",
                    username: "asdf",
                    accessToken: "a400a47dfd19457a823d854a90bcfc126de29624c56f40f7ac113004fed9a7ea"
                )
            )
        )
    )
    .frame(width: 800, height: 600)
}
