import SwiftUI
import DecksterLib

struct DrawPileCardView: View {
    let drawPileCount: Int
    
    var body: some View {
        HStack {
            
        }
        .foregroundStyle(.white)
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.vertical)
        .clipShape(.rect(cornerRadius: 12))
        .frame(width: 90, height: 120)
        .padding(2)
        .overlay {
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "square.stack.fill")
                    Text("\(drawPileCount)")
                        .font(.title)
                }
            }
            .foregroundStyle(.secondary)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.red.opacity(0.6))
                .stroke(.black)
        }
    }
}

#Preview {
    DrawPileCardView(drawPileCount: 4)
}
