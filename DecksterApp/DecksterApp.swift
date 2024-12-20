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
                Group {
                    switch gameConfig.gameType {
                    case .chatroom:
                        ChatroomView(gameConfig: gameConfig)
                    case .uno:
                        Text("Uno")
                    case .crazyEights:
                        CrazyEightsView(gameConfig: gameConfig)
                    case .idiot:
                        Text("Idiot")
                    }
                }
                .navigationTitle(gameConfig.gameId)
            } else {
                Text("No Game")
            }
        }
    }
}
