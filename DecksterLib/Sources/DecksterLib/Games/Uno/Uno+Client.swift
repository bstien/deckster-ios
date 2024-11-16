import Foundation

public enum Uno {}

extension Uno {
    public class Client: GameClient<Action, ActionResponse, Notification> {
        public init(
            hostname: String,
            gameId: String,
            players: [Player],
            accessToken: String
        ) throws {
            try super.init(
                hostname: hostname,
                gameType: .uno,
                gameId: gameId,
                players: players,
                accessToken: accessToken
            )
        }
    }
}
