import Foundation

extension Uno {
    public struct Card: Codable, Hashable {
        public let value: Value
        public let color: String

        public init(value: Value, color: String) {
            self.value = value
            self.color = color
        }
    }
}

extension Uno.Card {
    public enum Value: String, Codable {
        case zero = "Zero" // 0
        case one = "One" // 1
        case two = "Two" // 2
        case three = "Three" // 3
        case four = "Four" // 4
        case five = "Five" // 5
        case six = "Six" // 6
        case seven = "Seven" // 7
        case eight = "Eight" // 8
        case nine = "Nine" // 9
        case skip = "Skip" // 21
        case reverse = "Reverse" // 22
        case drawTwo = "DrawTwo" // 23
        case wild = "Wild" // 51
        case wildDrawFour = "WildDrawFour" // 52
    }

    public enum Color: String, Codable {
        case red = "Red"
        case yellow = "Yellow"
        case green = "Green"
        case blue = "Blue"
        case wild = "Wild"
    }
}
