import Foundation

struct DecksterResponse<Kind: Decodable>: Decodable {
    let kind: Kind
    let error: String?

    private enum CodingKeys: String, CodingKey {
        case kind = "type"
        case error
    }
}
