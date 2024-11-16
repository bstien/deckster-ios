import SwiftUI
import DecksterLib

struct YourCardsView: View {
    let cards: [Card]
    let cardSelected: (Card) -> Void
    @State private var width: CGFloat?

    var body: some View {
        ZStack {
            CardView(card: Card(rank: 1, suit: .clubs))
                .opacity(0)

            ScrollView(.horizontal) {
                HStack {
                    Spacer()
                    ForEach(cards, id: \.self) { card in
                        CardView(card: card)
                            .onTapGesture {
                                cardSelected(card)
                            }
                    }
                    Spacer()
                }
                .frame(minWidth: width)
                .padding(.bottom, -15)
                .animation(.spring, value: cards)
            }
        }
        .widthReader { width in
            self.width = width
        }
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
            cards: cards,
            cardSelected: {
                print("Selected card \($0.displayValue)")
            }
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
