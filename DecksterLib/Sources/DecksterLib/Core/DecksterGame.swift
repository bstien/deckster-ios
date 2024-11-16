import Foundation

public struct DecksterGame: Codable, Identifiable, Hashable {
    public var id: String { name }
    public let name: String
    public let state: State
    public let players: [Player]
    
    public init(name: String, state: State, players: [Player]) {
        self.name = name
        self.state = state
        self.players = players
    }
}

extension DecksterGame {
    public enum State: String, Codable, Hashable {
        case waiting = "Waiting"
        case running = "Running"
        case finished = "Finished"
        case roundFinished = "RoundFinished"
    }
}
