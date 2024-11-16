import SwiftUI

struct LogView: View {
    let messages: [LogMessage]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Game log")
                .font(.title3)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        Text(message.text)
                            .foregroundStyle(message.color)
                            .bold(message.isBold)
                            .font(.callout)
                    }
                }
            }
        }
    }
}

struct LogMessage: Identifiable {
    let id = UUID()
    let text: String
    let color: Color
    let isBold: Bool

    init(text: String, color: Color = .primary, isBold: Bool = false) {
        self.text = text
        self.color = color
        self.isBold = isBold
    }
}

#Preview {
    LogView(
        messages: [
            LogMessage(text: "Hei"),
            LogMessage(text: "Hei", color: .red),
            LogMessage(text: "Hei", color: .red, isBold: true),
            LogMessage(text: "Hei", isBold: true),
        ]
    )
    .frame(width: 200)
    .padding()
}
