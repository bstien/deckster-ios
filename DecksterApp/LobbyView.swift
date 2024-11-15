import SwiftUI
import DecksterLib

struct LobbyView: View {
    @State private var viewModel: ViewModel
    @Environment(\.openWindow) var openWindow

    init(game: Endpoint, userConfig: UserConfig) {
        viewModel = ViewModel(
            game: game,
            userConfig: userConfig
        )
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Ongoing games")
                        .font(.title3)
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.activeGames) { activeGame in
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
                                    let gameConfig = GameConfig(
                                        game: viewModel.game,
                                        gameId: activeGame.name,
                                        userConfig: viewModel.userConfig
                                    )
                                    openWindow(value: gameConfig)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("Ended games")
                        .font(.title3)
                    List {}
                }
                .frame(maxWidth: .infinity)
            }
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
    }
}

extension LobbyView {
    @Observable
    class ViewModel {
        let game: Endpoint
        let userConfig: UserConfig
        var activeGames = [DecksterGame]()
        private let lobbyClient: LobbyClient

        init(game: Endpoint, userConfig: UserConfig) {
            self.game = game
            self.userConfig = userConfig
            lobbyClient = LobbyClient(
                hostname: userConfig.host,
                game: game,
                accessToken: userConfig.userModel.accessToken
            )
        }

        func createGame() async -> GameConfig? {
            do {
                let createdGame = try await lobbyClient.createGame(name: "langsom avstand")
                print(createdGame)
                return GameConfig(
                    game: game,
                    gameId: createdGame.id,
                    userConfig: userConfig
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
        game: .chatroom,
        userConfig: userConfig
    )
}
