//
//  EquatableNoop.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 28/10/2022.
//

@propertyWrapper
public struct EquatableNoop<Value>: Equatable {
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }
}
