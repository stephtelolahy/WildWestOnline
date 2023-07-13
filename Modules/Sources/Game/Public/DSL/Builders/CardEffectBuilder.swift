//
//  CardEffectBuilder.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

@resultBuilder
public struct CardEffectsBuilder {

    public static func buildBlock(_ components: CardEffect...) -> [CardEffect] {
        components
    }
}

@resultBuilder
public struct CardEffectBuilder {

    public static func buildBlock(_ component: CardEffect) -> CardEffect {
        component
    }
}
