//
//  UserDefaultsStored.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Foundation

@propertyWrapper
struct UserDefaultsStored<T> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults

    var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
            storage.synchronize()
        }
    }

    init(_ key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

@propertyWrapper
struct OptionalUserDefaultsStored<T> {
    private let key: String
    private let storage: UserDefaults

    var wrappedValue: T? {
        get {
            storage.object(forKey: key) as? T
        }
        set {
            storage.set(newValue, forKey: key)
            storage.synchronize()
        }
    }

    init(_ key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.storage = storage
    }
}
