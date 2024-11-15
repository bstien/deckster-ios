import Foundation

public struct DecksterGame: Decodable, Identifiable {
    public var id: String { name }
    public let name: String
    public let state: State
    public let players: [Player]
}

extension DecksterGame {
    public enum State: String, Decodable {
        case waiting = "Waiting"
        case running = "Running"
        case finished = "Finished"
        case roundFinished = "RoundFinished"
    }
}
