import SwiftUI
import DecksterLib

struct ChatroomView: View {
    @State private var viewModel: ViewModel

    init(gameConfig: GameConfig) {
        viewModel = ViewModel(gameConfig: gameConfig)
    }

    var body: some View {
        ChatView(
            messageToSend: $viewModel.messageToSend,
            messages: viewModel.messages,
            sendMessageTapped: viewModel.sendMessage
        )
        .onAppear() {
            Task {
                await viewModel.connect()
            }
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
        var messageToSend: String = ""
        var messages: [ChatMessage] = []

        init(gameConfig: GameConfig) {
            self.gameConfig = gameConfig
            
            client = Chatroom.Client(
                hostname: gameConfig.userConfig.host,
                gameId: gameConfig.gameId,
                players: gameConfig.players,
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
                                let playerName = gameConfig.players.first(where: { $0.id == message.sender })?.name ?? "Unknown"
                                
                                let message = ChatMessage(
                                    isYou: message.sender == gameConfig.userConfig.userModel.id,
                                    sender: playerName,
                                    body: message.message
                                )
                                messages.append(message)
                                messageToSend = ""
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
        
        func sendMessage(message: String) {
            Task {
                do {
                    try await client.send(message: message)
                } catch {
                    errorMessage = "Could not send message: \(error)"
                }
            }
        }
    }
}
