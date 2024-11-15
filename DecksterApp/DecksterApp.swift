import SwiftUI
import DecksterLib

@main
struct DecksterApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .frame(width: 800, height: 600)
        }

        WindowGroup(for: GameConfig.self) { $gameConfig in
            switch gameConfig?.game {
            case .chatroom:
                Text("Chatroom")
            case .uno:
                Text("Uno")
            case .crazyEights:
                Text("Crazy Eights")
            case .idiot:
                Text("Idiot")
            case .none:
                Text("No Game")
            }
        }
    }
}
