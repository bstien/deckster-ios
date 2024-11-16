import Foundation

public enum CrazyEights {}

extension CrazyEights {
    public class Client: GameClient<Action, ActionResponse, Notification> {
        public init(hostname: String, gameId: String, accessToken: String) {
            super.init(
                hostname: hostname,
                gameName: "crazyeights",
                gameId: gameId,
                accessToken: accessToken
            )
        }
    }
}
