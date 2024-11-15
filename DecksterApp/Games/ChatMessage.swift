import Foundation

struct ChatMessage: Hashable {
    let isYou: Bool
    let sender: String
    let body: String
}
