import Foundation

public struct UserModel: Codable, Hashable {
    public let id: String
    public let username: String
    public let accessToken: String

    public init(id: String, username: String, accessToken: String) {
        self.id = id
        self.username = username
        self.accessToken = accessToken
    }
}
