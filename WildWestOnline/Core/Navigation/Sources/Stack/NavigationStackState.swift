//
//  NavigationStackState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

public protocol Destination: Identifiable, Hashable, Codable, Sendable {}

public struct NavigationStackState<T: Destination>: Equatable, Codable {
    public var path: [T]
    public var sheet: T?

    public init(path: [T], sheet: T? = nil) {
        self.path = path
        self.sheet = sheet
    }
}
