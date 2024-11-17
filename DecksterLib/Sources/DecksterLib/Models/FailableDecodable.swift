import Foundation

struct FailableDecodable<Value: Decodable>: Decodable {
    let value: Value?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(Value.self)
    }
}

// MARK: - Decoding helpers

extension KeyedDecodingContainer {
    func decodeFailable<T: Decodable>(arrayOf failableType: T.Type, forKey key: Key) throws -> [T] {
        let failables = try decode([FailableDecodable<T>].self, forKey: key)
        return failables.compactMap { $0.value }
    }
}
