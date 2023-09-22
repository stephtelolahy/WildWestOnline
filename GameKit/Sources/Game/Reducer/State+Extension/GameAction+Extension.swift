//
//  GameAction+Extension.swift
//  
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredByCardNamed(_ cardName: String) -> Bool {
        if case let .resolve(_, ctx) = self,
              ctx.get(.card) == cardName {
            true
        } else {
            false
        }
    }

    func isEffectTriggeredByPlayer(_ player: String) -> Bool {
        if case let .resolve(_, ctx) = self,
                ctx.get(.actor) == player {
            true
        } else {
            false
        }
    }
}
