import SwiftUI
import DecksterLib

struct CrazyEightsPlaymat: View {
    let topCard: Card?

    var body: some View {
        if let topCard {
            CardView(card: topCard)
        } else {
            Text("No card... yet!")
        }
    }
}

#Preview {
    VStack {
        CrazyEightsPlaymat(topCard: nil)
        CrazyEightsPlaymat(topCard: Card(rank: 12, suit: .diamonds))
    }
}
