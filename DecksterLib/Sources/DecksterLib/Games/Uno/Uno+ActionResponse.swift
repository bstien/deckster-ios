import Foundation

extension Uno {
    public enum ActionResponse: Decodable {
        case empty
        case unoCard(Card)
        case viewOfGame(GameView)
        case error(String)

        enum CodingKeys: String, CodingKey {
            case kind = "type"
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let response = try container.decode(DecksterResponse<Kind>.self, forKey: .kind)

            if let error = response.error {
                self = .error(error)
                return
            }

            switch response.kind {
            case .unoCard:
                self = .unoCard(try UnoCardResponse(from: decoder).card)
            case .empty:
                self = .empty
            case .viewOfGame:
                self = .viewOfGame(try GameView(from: decoder))
            }
        }
    }

}

// MARK: - Response kind

extension Uno.ActionResponse {
    enum Kind: String, Decodable {
        case empty = "Common.EmptyResponse"
        case unoCard = "Uno.UnoCardResponse"
        case viewOfGame = "Uno.PlayerViewOfGame"
    }
}

// MARK: - Models

extension Uno.ActionResponse {
    struct UnoCardResponse: Decodable {
        let card: Uno.Card
    }
}
