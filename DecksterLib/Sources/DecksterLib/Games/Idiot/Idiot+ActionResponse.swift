import Foundation

extension Idiot {
    public enum ActionResponse: Decodable {
        case empty
        case swapCards(cardNowOnHand: Card, cardNowFacingUp: Card)
        case pullIn(cards: [Card])
        case drawCards(cards: [Card])
        case putBlindCard(attemptedCard: Card, pullInCards: [Card])
        case error(String)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let response = try container.decode(DecksterResponse<Kind>.self)

            if let error = response.error {
                self = .error(error)
                return
            }

            switch response.kind {
            case .empty:
                self = .empty
            case .swapCards:
                let model = try SwapCards(from: decoder)
                self = .swapCards(cardNowOnHand: model.cardNowOnHand, cardNowFacingUp: model.cardNowFacingUp)
            case .pullIn:
                let model = try PullIn(from: decoder)
                self = .pullIn(cards: model.cards)
            case .drawCards:
                let model = try DrawCards(from: decoder)
                self = .drawCards(cards: model.cards)
            case .putBlindCard:
                let model = try PutBlindCard(from: decoder)
                self = .putBlindCard(attemptedCard: model.attemptedCard, pullInCards: model.pullInCards)
            }
        }
    }

}

// MARK: - Response kind

extension Idiot.ActionResponse {
    enum Kind: String, Decodable {
        case empty = "Common.EmptyResponse"
        case swapCards = "Idiot.SwapCardsResponse"
        case drawCards = "Idiot.DrawCardsResponse"
        case putBlindCard = "Idiot.PutBlindCardResponse"
        case pullIn = "Idiot.PullInResponse"
    }
}

// MARK: - Models

extension Idiot.ActionResponse {
    struct SwapCards: Decodable {
        let cardNowOnHand: Card
        let cardNowFacingUp: Card
    }

    struct PullIn: Decodable {
        let cards: [Card]
    }

    struct DrawCards: Decodable {
        let cards: [Card]
    }

    struct PutBlindCard: Decodable {
        let attemptedCard: Card
        let pullInCards: [Card]
    }
}
