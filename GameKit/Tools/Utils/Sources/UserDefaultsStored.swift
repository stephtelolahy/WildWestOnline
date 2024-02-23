//
//  UserDefaultsStored.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Foundation

@propertyWrapper
public struct UserDefaultsStored<T> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults

    public var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
            storage.synchronize()
        }
    }

    public init(_ key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}
