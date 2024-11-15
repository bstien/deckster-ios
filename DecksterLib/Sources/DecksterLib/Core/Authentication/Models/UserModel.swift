import Foundation

public struct UserModel: Codable, Hashable {
    public let username: String
    public let accessToken: String

    public init(username: String, accessToken: String) {
        self.username = username
        self.accessToken = accessToken
    }
}
