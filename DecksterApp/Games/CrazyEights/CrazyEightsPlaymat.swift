import SwiftUI
import DecksterLib

struct CrazyEightsPlaymat: View {
    let currentSuit: Card.Suit?
    let topCard: Card?

    var body: some View {
        VStack(spacing: 25) {
            CardView(card: topCard)

            if let currentSuit {
                VStack {
                    Text("Current suit:")
                        .bold()
                    Text(currentSuit.stringValue)
                        .font(.largeTitle)
                        .foregroundStyle(currentSuit.color)
                }
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
