import Foundation

extension CrazyEights {
    public struct OtherPlayer: Decodable, Identifiable {
        public let id: String
        public let name: String
        public let numberOfCards: Int

        public init(id: String, name: String, numberOfCards: Int) {
            self.id = id
            self.name = name
            self.numberOfCards = numberOfCards
        }

        enum CodingKeys: String, CodingKey {
            case id = "playerId"
            case name
            case numberOfCards
        }
    }
}
