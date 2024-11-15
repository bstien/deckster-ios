import Foundation

public struct UserModel: Decodable {
    public let username: String
    public let accessToken: String

    public init(username: String, accessToken: String) {
        self.username = username
        self.accessToken = accessToken
    }
}
