import Foundation

extension CrazyEights {
    public enum ActionResponse: Decodable {
        case empty
        case card(Card)
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
            case .card:
                self = .card(try CardResponse(from: decoder).card)
            case .empty:
                self = .empty
            case .viewOfGame:
                self = .viewOfGame(try GameView(from: decoder))
            }
        }
    }

}

// MARK: - Response kind

extension CrazyEights.ActionResponse {
    enum Kind: String, Decodable {
        case empty = "Common.EmptyResponse"
        case card = "CrazyEights.CardResponse"
        case viewOfGame = "CrazyEights.PlayerViewOfGame"
    }
}

// MARK: - Models

extension CrazyEights.ActionResponse {
    struct CardResponse: Decodable {
        let card: Card
    }
}
