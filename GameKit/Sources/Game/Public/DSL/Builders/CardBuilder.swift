//
//  CardBuilder.swift
//  
//
//  Created by Hugues Telolahy on 25/03/2023.
//

@resultBuilder
public struct CardBuilder {

    public static func buildBlock(_ components: Card...) -> [Card] {
        components
    }

    public static func buildExpression(_ card: Card) -> Card {
        card
    }
}
