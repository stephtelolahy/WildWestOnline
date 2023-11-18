//
//  CardEffectsBuilder.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

@resultBuilder
public enum CardEffectsBuilder {
    public static func buildBlock(_ components: CardEffect...) -> [CardEffect] {
        components
    }
}
