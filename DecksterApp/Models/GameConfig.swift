import Foundation
import DecksterLib

struct GameConfig: Codable, Hashable {
    let game: Endpoint
    let gameId: String
    let userConfig: UserConfig
}
