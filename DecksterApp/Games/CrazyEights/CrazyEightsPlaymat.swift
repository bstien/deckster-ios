import SwiftUI
import DecksterLib

struct CrazyEightsPlaymat: View {
    let topCard: Card?

    var body: some View {
        if let topCard {
            CardView(card: topCard)
        } else {
            CardView(card: nil)
        }
    }
}

#Preview {
    VStack {
        CrazyEightsPlaymat(topCard: nil)
        CrazyEightsPlaymat(topCard: Card(rank: 12, suit: .diamonds))
    }
}
