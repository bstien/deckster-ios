import Foundation

public final class LobbyClient<Notification: Decodable> {
    private let hostname: String
    private let gameType: Endpoint
    private let accessToken: String
    private let urlSession: URLSession

    public init(
        hostname: String,
        gameType: Endpoint,
        accessToken: String,
        urlSession: URLSession = .shared
    ) {
        self.hostname = hostname
        self.gameType = gameType
        self.accessToken = accessToken
        self.urlSession = urlSession
    }

    public func createGame(name: String? = nil) async throws -> GameCreated {
        let urlString = "http://\(hostname)/\(gameType.rawValue)/create" + (name.map { "/\($0)" } ?? "")
        let urlRequest = try URLRequest.create(urlString, method: "POST", accessToken: accessToken)
        let (data, _) = try await urlSession.data(for: urlRequest)
        return try JSONDecoder().decode(GameCreated.self, from: data)
    }

    public func getActiveGames() async throws -> [DecksterGame] {
        let urlString = "http://\(hostname)/\(gameType.rawValue)/games"
        let urlRequest = try URLRequest.create(urlString, accessToken: accessToken)
        let (data, _) = try await urlSession.data(for: urlRequest)
        return try JSONDecoder().decode([DecksterGame].self, from: data)
    }

    public func getHistoricGames() async throws -> [HistoricGame<Notification>] {
        let urlString = "http://\(hostname)/\(gameType.rawValue)/previousgames"
        let urlRequest = try URLRequest.create(urlString, accessToken: accessToken)
        let (data, _) = try await urlSession.data(for: urlRequest)
        return try JSONDecoder().decode([FailableDecodable<HistoricGame<Notification>>].self, from: data).compactMap(\.value)
    }
}

public struct GameCreated: Decodable {
    public let id: String
}
