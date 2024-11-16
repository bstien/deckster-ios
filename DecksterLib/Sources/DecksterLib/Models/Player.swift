import Foundation

public struct Player: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let points: Int
    public let cardsInHand: Int
    public let interestingFacts: [String: String]?
}
