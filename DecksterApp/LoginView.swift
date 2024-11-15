import SwiftUI
import DecksterLib

struct LoginView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        if let configuration = viewModel.configuration {
            LobbyView(game: .chatroom, configuration: configuration)
        } else {
            VStack {
                TextField("Username", text: $viewModel.username)
                TextField("Password", text: $viewModel.password)
                TextField("Host", text: $viewModel.host)
                Button("Login") {
                    Task {
                        await viewModel.login()
                    }
                }
            }
            .padding()
        }
    }
}

extension LoginView {
    @Observable
    class ViewModel {
        var username: String = "asdf"
        var password: String = "asdf"
        var host: String = "localhost:13992"
        var errorMessage: String?
        var configuration: Configuration?

        func login() async {
            let loginClient = LoginClient(hostname: host)
            print(host)
            do {
                let userModel = try await loginClient.login(username: username, password: password)
                let configuration = Configuration(
                    host: host,
                    userModel: userModel
                )
                self.configuration = configuration
                print(configuration)
            } catch {
                errorMessage = error.localizedDescription
                print(error)
            }
        }
    }
}

#Preview {
    LoginView()
}
