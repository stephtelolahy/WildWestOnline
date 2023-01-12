//
//  EquatableNoop.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Ignore an object for Equatable Conformance
/// See https://medium.com/@dhavalshreyas/ignore-variables-for-equatable-conformance-in-swift-2f489fab76d9
@propertyWrapper
struct EquatableNoop<Value>: Equatable {
    var wrappedValue: Value
    
    static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }
}
