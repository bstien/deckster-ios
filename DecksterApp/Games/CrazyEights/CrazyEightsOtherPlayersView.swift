import SwiftUI
import DecksterLib

struct CrazyEightsOtherPlayersView: View {
    let otherPlayers: [CrazyEights.OtherPlayer]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Other players")
                .font(.title3)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(otherPlayers) { player in
                        VStack(alignment: .leading) {
                            Text(player.name)
                                .lineLimit(1)
                            HStack {
                                Image(systemName: "square.stack.fill")
                                Text("\(player.numberOfCards)")
                            }
                            .font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CrazyEightsOtherPlayersView(
        otherPlayers: [
            .init(id: "1", name: "Knikt Knokt", numberOfCards: 12),
            .init(id: "2", name: "Pølse Larsen", numberOfCards: 34),
            .init(id: "3", name: "Mikk MokkesenMokkesen", numberOfCards: 56),
        ]
    )
    .frame(width: 200)
    .padding()
}
