import SwiftUI
import DecksterLib

struct ChatroomView: View {
    @State private var viewModel: ViewModel

    init(gameConfig: GameConfig) {
        viewModel = ViewModel(gameConfig: gameConfig)
    }

    var body: some View {
        // Use `ChatView` here
        Text("Hey")
            .onAppear {
                Task { await viewModel.connect() }
            }
    }
}

extension ChatroomView {
    @Observable
    class ViewModel {
        let gameConfig: GameConfig
        let client: Chatroom.Client
        var notificationTask: Task<Void, Never>?
        var errorMessage: String?

        init(gameConfig: GameConfig) {
            self.gameConfig = gameConfig
            client = Chatroom.Client(
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
                            switch notification {
                            case .message(let message):
                                print(message)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ChatroomView(
        gameConfig: GameConfig(
            game: .chatroom,
            gameId: "transitiv seng",
            userConfig: UserConfig(
                host: "localhost:13992",
                userModel: UserModel(
                    username: "asdf",
                    accessToken: "91e8cf5a891f4f98b2fc6f6804ec66bf19f2921dbc274b908ed1f008f1f97728"
                )
            )
        )
    )
}
