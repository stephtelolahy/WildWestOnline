//
//  ClassWrapper.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//

/// Holding value type in class
public class ClassWrapper<T> {
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
}
