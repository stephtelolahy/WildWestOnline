//
//  UncheckedEquatable.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 03/11/2024.
//

@propertyWrapper
public struct UncheckedEquatable: Equatable, Codable, Sendable {
    public var wrappedValue: String

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }

    public init(from decoder: any Decoder) throws {
        fatalError("No implemented")
    }

    public func encode(to encoder: any Encoder) throws {
    }
}
