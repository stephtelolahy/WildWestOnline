//
//  CardRuleBuilder.swift
//
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Foundation

@resultBuilder
public struct CardRuleBuilder {

    public static func buildBlock(_ components: CardRule...) -> [CardRule] {
        components
    }
}

public struct CardRule: Codable, Equatable {

    /// Conditions to play a card
    let playReq: PlayReq

    /// Card Side-effect
    let effect: CardEffect
}
