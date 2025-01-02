//
//  UncheckedEquatable.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 03/11/2024.
//

@propertyWrapper
struct UncheckedEquatable: Equatable, Codable, Sendable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }

    init(from decoder: any Decoder) throws {
        fatalError("No implemented")
    }

    func encode(to encoder: any Encoder) throws {
    }
}
