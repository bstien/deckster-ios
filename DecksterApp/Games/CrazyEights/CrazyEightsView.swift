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

            Text(viewModel.errorMessage ?? "")
                .foregroundColor(.red)
                .padding()

            HStack {
                Button("Pass turn") { viewModel.sendAction(.pass) }
                    .disabled(!viewModel.itIsYourTurn)
                Button("Draw card") { viewModel.sendAction(.drawCard) }
                    .disabled(!viewModel.itIsYourTurn)
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
                        viewModel.itIsYourTurn ? .clear : .gray.opacity(0.8)
                    )
                }
                .padding([.leading, .trailing, .top])
            }
        }
        .overlay {
            if !viewModel.isGameStarted {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.8))

                    Button("Start game") {
                        viewModel.startGame()
                    }
                }
            } else if let crazyEightCard = viewModel.crazyEightCard {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.8))
                    CrazyEightsSuitSelector(didSelectSuit: { newSuit in
                        viewModel.sendAction(.putEight(card: crazyEightCard, newSuit: newSuit))
                    })
                }
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

        var crazyEightCard: Card?
        var isGameStarted = false
        var itIsYourTurn = false
        var currentSuit: Card.Suit?
        var yourCards = [Card]()
        var topCard: Card?
        var errorMessage: String?

        init(gameConfig: GameConfig) {
            self.gameConfig = gameConfig

            client = CrazyEights.Client(
                hostname: gameConfig.userConfig.host,
                gameId: gameConfig.gameId,
                players: [],
                accessToken: gameConfig.userConfig.userModel.accessToken
            )
        }

        func connect() async {
            do {
                try await client.connect()

                notificationTask = Task {
                    do {
                        for try await notification in client.notificationStream {
                            isGameStarted = true
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

        func startGame() {
            Task {
                do {
                    try await client.startGame()
                } catch {
                    print(error)
                }
            }
        }

        func sendAction(_ action: CrazyEights.Action) {
            Task {
                do {
                    let response = try await client.sendAction(action)
                    handleResponse(response)
                } catch {
                    print(error)
                }
            }
        }

        func cardSelected(_ card: Card) {
            if card.rank == 8 {
                crazyEightCard = card
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
                errorMessage = nil
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
            itIsYourTurn = false
            crazyEightCard = nil
            errorMessage = nil

            switch actionResponse {
            case .empty:
                break
            case .card(let card):
                yourCards.append(card)
            case .viewOfGame(let gameView):
                itIsYourTurn = true
                setGameView(gameView)
            case .error(let errorMessage):
                self.errorMessage = errorMessage
                print(errorMessage)
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
            gameType: .chatroom,
            userConfig: UserConfig(
                host: "localhost:13992",
                userModel: UserModel(
                    id: "1234",
                    username: "asdf",
                    accessToken: "a400a47dfd19457a823d854a90bcfc126de29624c56f40f7ac113004fed9a7ea"
                )
            ),
            gameId: "CRAZY_EIGHTS",
            players: []
        )
    )
    .frame(width: 800, height: 600)
}
