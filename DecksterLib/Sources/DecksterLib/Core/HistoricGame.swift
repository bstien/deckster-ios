import Foundation

public struct HistoricGame<Notification: Decodable>: Decodable, Identifiable {
    public var id: String { gameInfo.id }
    public let gameInfo: Info
    public let players: [Player]
    public let events: [Event<Notification>]

    enum CodingKeys: String, CodingKey {
        case gameInfo = "game"
        case players
        case events
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gameInfo = try container.decode(Info.self, forKey: .gameInfo)
        self.players = try container.decode([Player].self, forKey: .players)
        self.events = try container.decodeFailable(
            arrayOf: Event<Notification>.self,
            forKey: .events
        )
    }
}

extension HistoricGame {
    public struct Info: Decodable, Identifiable {
        public let id: String
        public let name: String
        public let startedTime: String
        public let discardPile: [Card]
    }

    public struct Player: Decodable, Identifiable, Hashable {
        public let id: String
        public let name: String
    }

    public struct Event<T: Decodable>: Decodable {
        public let playerId: String
        public let event: T
    }
}
