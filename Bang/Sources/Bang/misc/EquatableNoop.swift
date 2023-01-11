//
//  EquatableNoop.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Ignore an object in Equatable synthesizing
@propertyWrapper
struct EquatableNoop<Value>: Equatable {
    var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }
}
