import SwiftUI
import DecksterLib

struct LoginView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        if let userConfig = viewModel.userConfig {
            GameSelectorView(
                userConfig: userConfig
            )
        } else {
            VStack {
                TextField("Username", text: $viewModel.username)
                    .onSubmit {
                        login()
                    }
                TextField("Password", text: $viewModel.password)
                    .onSubmit {
                        login()
                    }
                TextField("Host", text: $viewModel.host)
                    .onSubmit {
                        login()
                    }
                Button("Login") {
                    login()
                }
            }
            .padding()
        }
    }
    
    func login() {
        Task {
            await viewModel.login()
        }
    }
}

extension LoginView {
    @Observable
    class ViewModel {
        var username: String = "Botzi"
        var password: String = "1234"
        var host: String = "platano.local:13992"
        var errorMessage: String?
        var userConfig: UserConfig?

        func login() async {
            let loginClient = LoginClient(hostname: host)
            print(host)
            do {
                let userModel = try await loginClient.login(username: username, password: password)
                let userConfig = UserConfig(
                    host: host,
                    userModel: userModel
                )
                self.userConfig = userConfig
                print(userConfig)
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
