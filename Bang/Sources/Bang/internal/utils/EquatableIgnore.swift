//
//  EquatableIgnore.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Ignore an object for Equatable Conformance
/// See https://medium.com/@dhavalshreyas/ignore-variables-for-equatable-conformance-in-swift-2f489fab76d9
@propertyWrapper
struct EquatableIgnore<Value>: Equatable {
    var wrappedValue: Value
    
    static func == (lhs: EquatableIgnore<Value>, rhs: EquatableIgnore<Value>) -> Bool {
        true
    }
}
