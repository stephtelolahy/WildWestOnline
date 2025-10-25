//
//  CardJSON.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 25/10/2025.
//

import Foundation

public struct CardJSON: Codable {
    public let name: String
    public let type: Card.CardType
    public let description: String
    public let effects: [EffectJSON]
}

public struct EffectJSON: Codable {
    public let trigger: Card.Trigger
    public let action: Card.Effect.Name
    public let selectors: [Card.Selector]
}
