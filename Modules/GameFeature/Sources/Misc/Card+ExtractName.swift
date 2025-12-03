//
//  Card+ExtractName.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

public extension Card {
    static func name(of identifier: String) -> String {
        identifier.split(separator: "-").first.map(String.init) ?? identifier
    }

    static func value(of identifier: String) -> String {
        identifier.split(separator: "-").dropFirst().first.map(String.init) ?? ""
    }
}
