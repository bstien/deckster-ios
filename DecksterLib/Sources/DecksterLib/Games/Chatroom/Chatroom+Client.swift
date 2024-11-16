import Foundation

public enum Chatroom {}

extension Chatroom {
    public class Client: GameClient<Action, ActionResponse, Notification> {
        public init(
            hostname: String,
            gameId: String,
            players: [Player],
            accessToken: String
        ) {
            super.init(
                hostname: hostname,
                gameType: .chatroom,
                gameId: gameId,
                players: players,
                accessToken: accessToken
            )
        }

        public func send(message: String) async throws {
            _ = try await sendAction(.send(message: message))
        }
    }
}
