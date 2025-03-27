//
//  DocumentConvertible.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Foundation

public protocol DocumentConvertible {
    var dictionary: [String: Any] { get }

    init(dictionary: [String: Any]) throws
}

/// Extension allowing serialization to a Document data
public extension DocumentConvertible where Self: Codable {
    var dictionary: [String: Any] {
        guard let dict = try? JSONEncoder().encodeToDictionary(self) else {
            fatalError("unexpected")
        }

        return dict
    }

    init(dictionary: [String: Any]) throws {
        guard let model = try? JSONDecoder().decode(Self.self, from: dictionary) else {
            fatalError("unexpected")
        }

        self = model
    }
}

private extension JSONEncoder {
    func encodeToDictionary<T>(_ value: T) throws -> [String: Any]? where T: Encodable {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

private extension JSONDecoder {
    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decode(type, from: data)
    }
}
