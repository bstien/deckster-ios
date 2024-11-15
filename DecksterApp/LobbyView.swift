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
                    List {}
                }
                VStack {
                    Text("Ended games")
                    List {}
                }
            }
            .padding(.top)

            Button("Create game") {
                Task {
                    if let createdGame = await viewModel.createGame() {
                        // Navigate
                    } else {
                        // Show error
                    }
                }
            }
            .padding()
        }
    }
}

extension LobbyView {
    @Observable
    class ViewModel {
        let game: Endpoint
        let userConfig: UserConfig
        private let lobbyClient: LobbyClient

        init(game: Endpoint, userConfig: UserConfig) {
            self.game = game
            self.userConfig = userConfig
            lobbyClient = LobbyClient(
                hostname: userConfig.host,
                accessToken: userConfig.userModel.accessToken
            )
        }

        func createGame() async -> GameConfig? {
            do {
                let createdGame = try await lobbyClient.createGame(game: game)
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
    }
}

#Preview {
    let userConfig = UserConfig(
        host: "localhost:13992",
        userModel: UserModel(
            username: "asdf",
            accessToken: "91e8cf5a891f4f98b2fc6f6804ec66bf19f2921dbc274b908ed1f008f1f97728"
        )
    )
    LobbyView(
        game: .chatroom,
        userConfig: userConfig
    )
}
