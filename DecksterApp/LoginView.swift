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
        var username: String = "Otzi"
        var password: String = "1234"
        var host: String = "192.168.0.134:13992"
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
