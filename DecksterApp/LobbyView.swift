import SwiftUI
import DecksterLib

struct LobbyView: View {
    @State private var viewModel: ViewModel
    @Environment(\.openWindow) var openWindow

    init(gameType: Endpoint, userConfig: UserConfig) {
        viewModel = ViewModel(
            gameType: gameType,
            userConfig: userConfig
        )
    }

    var body: some View {
        VStack {
            HStack {
                getOnGoingGameView()
                    .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Ended games")
                        .font(.title3)
                    List {}
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            
            Button("Create game") {
                Task {
                    if let createdGame = await viewModel.createGame() {
                        openWindow(value: createdGame)
                    } else {
                        // Show error
                    }
                }
            }
            .padding()
            .task {
                while !Task.isCancelled {
                    await viewModel.fetchGames()
                    try? await Task.sleep(for: .seconds(1))
                }
            }
        }
        .navigationTitle("\(viewModel.gameType.rawValue.capitalized) lobby")
    }
    
    func getOnGoingGameView() -> some View {
        VStack {
            Text("Ongoing games")
                .font(.title3)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.activeGames, id: \.self) { activeGame in
                        VStack(alignment: .leading) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(activeGame.name)
                                    .bold()
                                Spacer()
                                Text(activeGame.state.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .italic()
                            }
                            Text("\(activeGame.players.count) players")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            if isUserInGame(activeGame) { return }
                            let gameConfig = GameConfig(
                                gameType: viewModel.gameType,
                                userConfig: viewModel.userConfig,
                                gameId: activeGame.name,
                                players: activeGame.players
                            )
                            openWindow(value: gameConfig)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func isUserInGame(_ game: DecksterGame) -> Bool {
        game.players.contains(where: { $0.id == viewModel.userConfig.userModel.id })
    }
}

extension LobbyView {
    @Observable
    class ViewModel {
        let gameType: Endpoint
        let userConfig: UserConfig
        var activeGames = [DecksterGame]()
        private let lobbyClient: LobbyClient

        init(gameType: Endpoint, userConfig: UserConfig) {
            self.gameType = gameType
            self.userConfig = userConfig
            lobbyClient = LobbyClient(
                hostname: userConfig.host,
                gameType: gameType,
                accessToken: userConfig.userModel.accessToken
            )
        }

        func createGame() async -> GameConfig? {
            do {
                let createdGame = try await lobbyClient.createGame()
                print(createdGame)
                
                return GameConfig(
                    gameType: gameType,
                    userConfig: userConfig,
                    gameId: createdGame.id,
                    players: []
                )
            } catch {
                print(error)
            }
            return nil
        }

        func fetchGames() async {
            do {
                activeGames = try await lobbyClient.getActiveGames()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    let userConfig = UserConfig(
        host: "localhost:13992",
        userModel: UserModel(
            id: "1234",
            username: "asdf",
            accessToken: "91e8cf5a891f4f98b2fc6f6804ec66bf19f2921dbc274b908ed1f008f1f97728"
        )
    )
    LobbyView(
        gameType: .chatroom,
        userConfig: userConfig
    )
}
