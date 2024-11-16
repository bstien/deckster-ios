import Foundation
import DecksterLib

struct GameConfig: Codable, Hashable {
    let gameType: Endpoint
    let userConfig: UserConfig
    let gameId: String
    let players: [Player]
}
