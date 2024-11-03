//
//  EquatableNoop.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 03/11/2024.
//

@propertyWrapper
public struct EquatableNoop<Value: Equatable>: Equatable, Codable {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }

    public init(from decoder: any Decoder) throws {
        fatalError("No implemented")
    }

    public func encode(to encoder: any Encoder) throws {
    }
}
