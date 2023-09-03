//
//  CardRuleBuilder.swift
//
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Foundation

@resultBuilder
public struct CardRuleBuilder {

    public static func buildBlock(_ components: CardRules...) -> [CardRules] {
        components
    }
}
