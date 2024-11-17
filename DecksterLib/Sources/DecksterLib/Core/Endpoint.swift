import Foundation

public enum Endpoint: String, Codable, Hashable {
    case chatroom
    case uno
    case idiot
    case crazyEights = "crazyeights"

    var notificationType: Decodable.Type {
        switch self {
        case .chatroom:
            Chatroom.Notification.self
        case .crazyEights:
            CrazyEights.Notification.self
        case .uno:
            Uno.Notification.self
        case .idiot:
            Idiot.Notification.self
        }
    }
}
