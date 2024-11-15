import SwiftUI

@main
struct DecksterApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .frame(width: 800, height: 600)
        }
    }
}
