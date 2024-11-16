import SwiftUI
import DecksterLib

@main
struct DecksterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .frame(width: 800, height: 600)
        }

        WindowGroup(for: GameConfig.self) { $gameConfig in
            if let gameConfig {
                switch gameConfig.game {
                case .chatroom:
                    ChatroomView(gameConfig: gameConfig)
                case .uno:
                    Text("Uno")
                case .crazyEights:
                    Text("Crazy Eights")
                case .idiot:
                    Text("Idiot")
                }
            } else {
                Text("No Game")
            }
        }
    }
}
