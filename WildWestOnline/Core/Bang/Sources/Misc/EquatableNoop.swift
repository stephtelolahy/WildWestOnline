//
//  EquatableNoop.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 03/11/2024.
//

@propertyWrapper
struct EquatableNoop<Value: Equatable>: Equatable, Codable {
    var wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }

    init(from decoder: any Decoder) throws {
        fatalError()
    }

    func encode(to encoder: any Encoder) throws {
        fatalError()
    }
}
