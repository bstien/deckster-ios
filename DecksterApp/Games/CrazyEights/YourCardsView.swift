import SwiftUI
import DecksterLib

struct YourCardsView: View {
    let cards: [Card]

    var body: some View {
        ZStack {
            CardView(card: Card(rank: 1, suit: .clubs))
                .padding(.bottom, -12)
                .opacity(0)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(cards, id: \.self) { card in
                        CardView(card: card)
                    }
                }
                .padding(.bottom, -12)
            }
        }
        .animation(.easeInOut, value: cards)
    }
}

#Preview {
    @Previewable @State var cards: [Card] = [
        .init(rank: 1, suit: .hearts),
        .init(rank: 2, suit: .diamonds),
        .init(rank: 12, suit: .spades),
    ]

    VStack {
        YourCardsView(
            cards: cards
        )

        Button("Random card") {
            cards.append(Card.randomCard)
        }
    }
}

extension Card {
    static var randomCard: Card {
        let rank = Int.random(in: 1...12)
        let suits: [Card.Suit] = [.hearts, .diamonds, .spades, .clubs]
        let suit = suits.randomElement()!
        return Card(rank: rank, suit: suit)
    }
}
