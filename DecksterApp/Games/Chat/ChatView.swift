import SwiftUI
import DecksterLib

// Dårlig navn. Separarerte dette ut så vi kan lage previews av viewet uten å bruke nettverk.
struct ChatView: View {
    @Binding var messageToSend: String
    let messages: [ChatMessage]
    var sendMessageTapped: (String) -> Void

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    VStack(alignment: message.isYou ? .trailing : .leading) {
                        Text(message.sender)
                            .padding(0)
                        Text(message.body)
                            .frame(alignment: message.isYou ? .trailing : .leading)
                            .multilineTextAlignment(message.isYou ? .trailing : .leading)
                            .padding()
                            .background(message.isYou ? .green : .blue)
                            .clipShape(.rect(cornerRadius: 7))
                            
                    }
                    .frame(maxWidth: .infinity, alignment: message.isYou ? .trailing : .leading)
                    .padding([.leading, .top, .trailing])
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
            }
            
            HStack {
                TextField("Message", text: $messageToSend)

                Button("Send") {
                    sendMessageTapped(messageToSend)
                }
            }.padding(.horizontal)
        }
    }
}

#Preview {
    @Previewable @State var messageToSend: String = ""
    @Previewable @State var messages = [ChatMessage]()
    ChatView(
        messageToSend: $messageToSend,
        messages: [
            ChatMessage(
                isYou: true,
                sender: "Bastian",
                body: "Finfin melding. Ganske flott melding, faktisk."
            ),
            ChatMessage(
                isYou: false,
                sender: "Ikke Bastian",
                body: "Enig – veldig fin melding."
            ),
        ],
        sendMessageTapped: { message in
            print(message)
            messages.append(.init(isYou: true, sender: "Me", body: message))
            messageToSend = "Hei"
        }
    )
}
