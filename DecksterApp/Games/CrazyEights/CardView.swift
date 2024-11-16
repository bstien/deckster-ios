import SwiftUI
import DecksterLib

struct CardView: View {
    let card: Card?

    var body: some View {
        HStack(spacing: 4) {
            if let card {
                Text(card.suit.stringValue)
                Text(card.rank.stringValue)
            }
        }
        .foregroundStyle(card?.suit.color ?? .white)
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.vertical)
        .clipShape(.rect(cornerRadius: 12))
        .frame(maxWidth: 90, maxHeight: 100)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(card != nil ?
                        .white :
                        Color.brown.opacity(0.2)
                )
                .stroke(
                    .black,
                    style: card != nil ?
                        StrokeStyle(lineWidth: 2) :
                        StrokeStyle(lineWidth: 2, dash: [5])
                )
        }
    }
}

#Preview {
    HStack{
        CardView(card: nil)
        .padding()
        CardView(card: Card(
            rank: 4, suit: .clubs
        ))
        .padding()
    }
}
