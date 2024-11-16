import Foundation

enum GameClientError: Error {
    case invalidHandshakeResponse
    case invalidUrl(String)
}

public class GameClient<Action: Encodable, ActionResponse: Decodable, Notification: Decodable> {

    // MARK: - Public properties

    public var notificationStream: AsyncThrowingStream<Notification, Error> {
        AsyncThrowingStream { continuation in
            guard let notificationSocket else {
                continuation.finish(throwing: WebSocketError.notConnected)
                return
            }

            Task {
                do {
                    for try await data in notificationSocket.messageStream {
                        print(String(data: data, encoding: .utf8))
                        let decodedMessage = try decoder.decode(Notification.self, from: data)
                        continuation.yield(decodedMessage)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // MARK: - Internal properties

    let hostname: String
    let gameType: Endpoint
    let gameId: String
    let players: [Player]
    let accessToken: String
    private(set) var isConnected = false

    // MARK: - Private properties

    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    private let actionSocket: WebSocketConnection
    private var notificationSocket: WebSocketConnection?

    // MARK: - Init

    init(
        hostname: String,
        gameType: Endpoint,
        gameId: String,
        players: [Player],
        accessToken: String,
        urlSession: URLSession = .shared
    ) {
        self.hostname = hostname
        self.gameType = gameType
        self.gameId = gameId
        self.players = players
        self.accessToken = accessToken
        self.urlSession = urlSession

        let urlString = "ws://\(hostname)/\(gameType.rawValue)/join/\(gameId)"
        let urlRequest = try! URLRequest.create(urlString, accessToken: accessToken)
        self.actionSocket = WebSocketConnection(urlRequest: urlRequest, urlSession: urlSession)
    }

    // MARK: - Public methods

    public func startGame() async throws {
        let urlString = "http://\(hostname)/\(gameType.rawValue)/games/\(gameId)/start"
        let urlRequest = try URLRequest.create(urlString, method: "POST", accessToken: accessToken)
        let (data, _) = try await urlSession.data(for: urlRequest)
        
        print(String(data: data, encoding: .utf8))
        print("Game started!")
    }

    public func connect() async throws {
        guard !isConnected else { return }
        actionSocket.connect()

        let data = try await actionSocket.receiveNextMessage()
        if let identifier = extractIdentifier(from: data) {
            print(identifier)
            try await openNotificationSocket(with: identifier)

            isConnected = true
        } else {
            throw GameClientError.invalidHandshakeResponse
        }
    }

    public func disconnect() {
        actionSocket.disconnect()
        notificationSocket?.disconnect()
    }

    public func sendAction(_ action: Action) async throws -> ActionResponse {
        try await actionSocket.send(action)
        let data = try await actionSocket.receiveNextMessage()
        print(String(data: data, encoding: .utf8))
        return try decoder.decode(ActionResponse.self, from: data)
    }

    // MARK: - Private methods

    private func openNotificationSocket(with identifier: String) async throws {
        let urlString = "ws://\(hostname)/\(gameType.rawValue)/join/\(identifier)/finish"
        let urlRequest = try URLRequest.create(urlString, accessToken: accessToken)
        let connection = WebSocketConnection(urlRequest: urlRequest)
        connection.connect()
        self.notificationSocket = connection

        let data = try await connection.receiveNextMessage()
        _ = try decoder.decode(NotificationSocketHandshake.self, from: data)
        print("Secondary WebSocket connected with identifier: \(identifier)")
    }

    private func extractIdentifier(from data: Data) -> String? {
        do {
            let response = try decoder.decode(HandshakeResponse.self, from: data)
            return response.connectionId
        } catch {
            print("Failed to decode identifier: \(error)")
            return nil
        }
    }
}
