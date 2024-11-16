import Foundation

public enum CrazyEights {}

extension CrazyEights {
    public class Client: GameClient<Action, ActionResponse, Notification> {
        public init(
            hostname: String,
            gameId: String,
            players: [Player],
            accessToken: String
        ) {
            super.init(
                hostname: hostname,
                gameType: .crazyEights,
                gameId: gameId,
                players: players,
                accessToken: accessToken
            )
        }
    }
}
