import SwiftUI
import DecksterLib

struct CrazyEightsPlaymat: View {
    let currentSuit: Card.Suit?
    let topCard: Card?
    let drawPileCount: Int?

    init(currentSuit: Card.Suit?, topCard: Card?, drawPileCount: Int?) {
        self.currentSuit = currentSuit
        self.topCard = topCard
        self.drawPileCount = drawPileCount
    }

    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 25) {
                CardView(card: topCard)
                DrawPileCardView(drawPileCount: drawPileCount ?? 0)
            }

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
        CrazyEightsPlaymat(
            currentSuit: nil,
            topCard: nil,
            drawPileCount: nil
        )

        CrazyEightsPlaymat(
            currentSuit: .diamonds,
            topCard: Card(rank: 12, suit: .diamonds),
            drawPileCount: 51
        )

        CrazyEightsPlaymat(
            currentSuit: .diamonds,
            topCard: nil,
            drawPileCount: 25
        )
    }
}
