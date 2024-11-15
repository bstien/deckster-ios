import SwiftUI
import DecksterLib

struct LobbyView: View {
    @State private var viewModel: ViewModel?

    init(game: Endpoint, configuration: Configuration) {
        viewModel = ViewModel(
            game: game,
            configuration: configuration
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

            }
            .padding()
        }
    }
}

extension LobbyView {
    @Observable
    class ViewModel {
        let game: Endpoint
        let configuration: Configuration

        init(game: Endpoint, configuration: Configuration) {
            self.game = game
            self.configuration = configuration
        }

        func createGame() async {

        }
    }
}

#Preview {
    let configuration = Configuration(
        host: "localhost:13992",
        userModel: UserModel(
            username: "asdf",
            accessToken: "91e8cf5a891f4f98b2fc6f6804ec66bf19f2921dbc274b908ed1f008f1f97728"
        )
    )
    LobbyView(
        game: .chatroom,
        configuration: configuration
    )
}
