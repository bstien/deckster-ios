import SwiftUI
import DecksterLib

struct GameSelectorView: View {
    @State private var viewModel: ViewModel
    let userConfig: UserConfig
    
    init(userConfig: UserConfig) {
        viewModel = ViewModel()
        self.userConfig = userConfig
    }
    
    var body: some View {
        HStack(spacing: 20) {
            GameSelectorButton(
                icon: "💬",
                label: "Chatroom",
                gameType: .chatroom,
                userConfig: userConfig
            )
            
            GameSelectorButton(
                icon: "🃈",
                label: "Crazy 8s",
                gameType: .crazyEights,
                userConfig: userConfig
            )
        }
        .navigationTitle("Select game")
    }
}

struct GameSelectorButton: View {
    let icon: String
    let label: String
    let gameType: Endpoint
    let userConfig: UserConfig
    
    var body: some View {
        NavigationLink(
            destination: {
                LobbyView(
                    gameType: gameType,
                    userConfig: userConfig
                )
            },
            label: {
                VStack(spacing: 10) {
                    Text(icon)
                        .font(.system(size: 50))
                        .clipShape(.rect(cornerRadius: 5))
                    
                    Text(label)
                        .font(.title)
                }
                .padding()
                .frame(maxWidth: 200, maxHeight: 200)
                .clipShape(.rect(cornerRadius: 15))
            }
        )
    }
}

extension GameSelectorView {
    @Observable
    class ViewModel {
        func goToGame(_ game: Endpoint) {
            print("Go to \(game)")
        }
    }
}
