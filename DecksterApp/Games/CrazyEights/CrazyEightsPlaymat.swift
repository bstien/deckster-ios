import SwiftUI
import DecksterLib

struct CrazyEightsPlaymat: View {
    let currentSuit: Card.Suit?
    let topCard: Card?

    var body: some View {
        VStack {
            if let currentSuit {
                HStack {
                    Text("Current suit:")
                        .bold()
                    Text(currentSuit.stringValue)
                        .font(.title3)
                        .foregroundStyle(currentSuit.color)
                }
            }

            if let topCard {
                CardView(card: topCard)
            } else {
                Text("No card... yet!")
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CrazyEightsPlaymat(currentSuit: nil, topCard: nil)
        CrazyEightsPlaymat(currentSuit: .diamonds, topCard: Card(rank: 12, suit: .diamonds))
    }
}
