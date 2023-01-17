//
//  EquatableCast.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Cast an object for Equatable Conformance
@propertyWrapper
public struct EquatableCast<Value>: Equatable {
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public static func == (lhs: EquatableCast<Value>, rhs: EquatableCast<Value>) -> Bool {
        lhs.isEqualTo(rhs)
    }
}

private extension EquatableCast {
    func isEqualTo(_ other: EquatableCast) -> Bool {
        guard let equatableSelf = self.wrappedValue as? (any Equatable),
              let equatableOther = other.wrappedValue as? (any Equatable) else {
            return false
        }
        
        return equatableSelf.isEqualCastedTo(equatableOther)
    }
}

private extension Equatable {
    func isEqualCastedTo(_ other: any Equatable) -> Bool {
        guard let castedOther = other as? Self else {
            return false
        }
        
        return castedOther == self
    }
}
