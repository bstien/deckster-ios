import Foundation
import DecksterLib

struct UserConfig: Codable, Hashable {
    let host: String
    let userModel: UserModel
}
