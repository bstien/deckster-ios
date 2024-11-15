import SwiftUI
import DecksterLib

struct YourCardView: View {
    let card: Card

    var body: some View {
        HStack(spacing: 4) {
            Text(card.rank.stringValue)
            Text(card.suit.stringValue)
        }
        .foregroundStyle(card.suit.color)
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.vertical)
        .clipShape(.rect(cornerRadius: 12))
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .stroke(Color.black, lineWidth: 2)
        }
    }
}

#Preview {
    YourCardView(
        card: Card(rank: 11, suit: .hearts)
    )
    .padding()
}
