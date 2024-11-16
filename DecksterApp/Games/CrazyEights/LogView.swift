import SwiftUI

struct LogView: View {
    let messages: [LogMessage]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Game log")
                .font(.title3)

            ScrollView {
                ScrollViewReader { value in
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            Text(message.text)
                                .foregroundStyle(message.color)
                                .bold(message.isBold)
                                .font(.callout)
                                .id(message.id)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onChange(of: messages.count) { _, _ in
                        value.scrollTo(messages.last?.id)
                    }
                }
            }
        }
    }
}

struct LogMessage: Identifiable, Hashable {
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
    @Previewable @State var messages: [LogMessage] = [
        LogMessage(text: "Hei"),
        LogMessage(text: "Hei", color: .red),
        LogMessage(text: "Hei", color: .red, isBold: true),
        LogMessage(text: "Hei", isBold: true),
    ]
    VStack {
        LogView(messages: messages)

        Button("Add") {
            messages.append(LogMessage(text: "Hei"))
        }
    }
    .frame(width: 200)
    .padding()
}
