import Foundation
import SwiftUI

public struct Card: Codable, Hashable {
    public typealias Rank = Int

    public let rank: Rank
    public let suit: Suit

    public init(rank: Int, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    public var displayValue: String {
        switch rank {
        case 0: rank.stringValue
        default: "\(rank.stringValue) \(suit.stringValue)"
        }
    }
}

extension Card.Rank {
    public var stringValue: String {
        switch self {
        case 0: "Joker"
        case 1: "A"
        case 2...10: "\(self)"
        case 11: "J"
        case 12: "Q"
        case 13: "K"
        default: fatalError("Invalid rank!")
        }
    }
}

extension Card {
    public enum Suit: String, Codable {
        case clubs = "Clubs"
        case diamonds = "Diamonds"
        case hearts = "Hearts"
        case spades = "Spades"

        public var stringValue: String {
            switch self {
            case .clubs: return "♣"
            case .diamonds: return "♦"
            case .hearts: return "♥"
            case .spades: return "♠"
            }
        }

        public var color: Color {
            switch self {
            case .clubs, .spades: .black
            case .diamonds, .hearts: .red
            }
        }
    }
}
