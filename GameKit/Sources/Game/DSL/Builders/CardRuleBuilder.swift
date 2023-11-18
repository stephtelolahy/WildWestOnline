//
//  CardRuleBuilder.swift
//
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Foundation

@resultBuilder
public enum CardRuleBuilder {
    public static func buildBlock(_ components: CardRule...) -> [CardRule] {
        components
    }
}
