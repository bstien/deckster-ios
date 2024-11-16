import SwiftUI
import DecksterLib

struct CrazyEightsView: View {
    @State private var viewModel: ViewModel

    init(gameConfig: GameConfig) {
        viewModel = ViewModel(gameConfig: gameConfig)
    }

    var body: some View {
        VStack {
            CrazyEightsPlaymat(topCard: viewModel.topCard)
                .frame(maxHeight: .infinity)
            Divider()
            YourCardsView(cards: viewModel.yourCards)
                .padding([.leading, .trailing, .top])
        }
    }
}

extension CrazyEightsView {
    @Observable
    class ViewModel {
        let gameConfig: GameConfig
        var yourCards = [Card]()
        var topCard: Card?

        init(gameConfig: GameConfig) {
            self.gameConfig = gameConfig
        }
    }
}

#Preview {
    CrazyEightsView(
        gameConfig: GameConfig(
            gameType: .chatroom,
            userConfig: UserConfig(
                host: "localhost:13992",
                userModel: UserModel(
                    id: "1234",
                    username: "asdf",
                    accessToken: "a400a47dfd19457a823d854a90bcfc126de29624c56f40f7ac113004fed9a7ea"
                )
            ),
            gameId: "CRAZY_EIGHTS",
            players: []
        )
    )
    .frame(width: 800, height: 600)
}
