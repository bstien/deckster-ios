import SwiftUI
import DecksterLib

struct CrazyEightsSuitSelector: View {
    var didSelectSuit: (Card.Suit) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Select new suit")
                .font(.largeTitle)
                .foregroundStyle(.black)
            HStack {
                selector(for: .spades)
                selector(for: .hearts)
                selector(for: .clubs)
                selector(for: .diamonds)
            }
            .font(.system(size: 40))
        }
        .padding(40)
        .clipShape(.rect(cornerRadius: 12))
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .stroke(.black, lineWidth: 1)
        }
    }

    private func selector(for suit: Card.Suit) -> some View {
        Button {
            didSelectSuit(suit)
            } label: {
                Text(suit.stringValue)
                    .foregroundStyle(suit.color)
                    .frame(width: 60, height: 60)
                    .clipShape(.rect(cornerRadius: 12))
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .stroke(.black, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
    }
}

#Preview {
    CrazyEightsSuitSelector(didSelectSuit: {
        print($0)
    })
    .padding()
}
