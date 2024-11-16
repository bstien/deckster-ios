import SwiftUI
import DecksterLib

struct CrazyEightsView: View {
    @State private var viewModel: ViewModel

    init(gameConfig: GameConfig) {
        viewModel = ViewModel(gameConfig: gameConfig)
    }

    var body: some View {
        VStack {
            HStack {
                CrazyEightsOtherPlayersView(otherPlayers: viewModel.otherPlayers)
                    .padding()
                    .frame(width: 200, alignment: .leading)

                VStack(spacing: 20) {
                    Text(viewModel.currentPlayer ?? "")
                        .font(.largeTitle)

                    CrazyEightsPlaymat(
                        currentSuit: viewModel.currentSuit,
                        topCard: viewModel.topCard,
                        drawPileCount: viewModel.drawPileCount
                    )
                    .frame(maxWidth: .infinity)
                }

                LogView(messages: viewModel.logMessages)
                    .padding()
                    .frame(width: 200, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

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
                .padding([.leading, .trailing, .top])
            }
        }
        .overlay {
            if let gameEndedMessage = viewModel.gameEndedMessage {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.8))

                    Text(gameEndedMessage)
                        .font(.system(size: 60, weight: .bold))
                }
            } else if !viewModel.isGameStarted {
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
        var otherPlayers: [CrazyEights.OtherPlayer] = []
        var logMessages: [LogMessage] = []
        var currentPlayer: String?
        var gameEndedMessage: String?
        var drawPileCount: Int?

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
            case .gameEnded(let loserId, let loserName, let players):
                if loserId == gameConfig.userConfig.userModel.id {
                    gameEndedMessage = "a loser is you"
                } else {
                    gameEndedMessage = "Hooray! \(loserName) lost the game"
                }
                log("Game has ended!", isBold: true)
            case .gameStarted(_, let viewOfGame):
                log("Game has begun!", isBold: true)
                setGameView(viewOfGame)
            case .itsYourTurn(let viewOfGame):
                log("It's your turn")
                currentPlayer = "You're up!"
                errorMessage = nil
                itIsYourTurn = true
                setGameView(viewOfGame)
            case .itsPlayersTurn(let playerId):
                if playerId != gameConfig.userConfig.userModel.id {
                    let player = getPlayer(id: playerId)
                    currentPlayer = "\(player)'s turn"
                    log("It's \(player)'s turn")
                }
            case .playerDrewCard(let playerId):
                let player = getPlayer(id: playerId)
                log("\(player) drew a card")
            case .playerIsDone(let playerId):
                let player = getPlayer(id: playerId)
                log("\(player) finished the turn")
            case .playerPassed(let playerId):
                let player = getPlayer(id: playerId)
                log("\(player) passed")
            case .playerPutCard(let playerId, let card):
                let player = getPlayer(id: playerId)
                log("\(player) played card \(card.displayValue)")
                topCard = card
            case .playerPutEight(let playerId, let card, let newSuit):
                let player = getPlayer(id: playerId)
                log("\(player) changed suit to \(newSuit.stringValue)")
                currentSuit = newSuit
                topCard = card
            case .discardPileShuffled:
                break
            }
        }

        private func handleResponse(_ actionResponse: CrazyEights.ActionResponse) {
            crazyEightCard = nil
            errorMessage = nil

            switch actionResponse {
            case .empty:
                itIsYourTurn = false
            case .card(let card):
                itIsYourTurn = true
                yourCards.append(card)
            case .viewOfGame(let gameView):
                itIsYourTurn = false
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
            otherPlayers = gameView.otherPlayers
            drawPileCount = gameView.stockPileCount
        }

        private func log(_ message: String, color: Color = .primary, isBold: Bool = false) {
            logMessages.append(LogMessage(text: message, color: color, isBold: isBold))
        }

        private func getPlayer(id: String) -> String {
            let player = otherPlayers.first(where: { $0.id == id })
            return player?.name ?? "You"
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
