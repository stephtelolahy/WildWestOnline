//
//  Card+ExtractName.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

public extension Card {
    /// Extract card name from cardId
    static func extractName(from identifier: String) -> String {
        identifier.split(separator: "-").first.map(String.init) ?? identifier
    }
}