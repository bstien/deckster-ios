import Foundation

public enum Idiot {}

extension Idiot {
    public class Client: GameClient<Action, ActionResponse, Notification> {
        public init(
            hostname: String,
            gameId: String,
            players: [Player],
            accessToken: String
        ) throws {
            try super.init(
                hostname: hostname,
                gameType: .idiot,
                gameId: gameId,
                players: players,
                accessToken: accessToken
            )
        }
    }
}
