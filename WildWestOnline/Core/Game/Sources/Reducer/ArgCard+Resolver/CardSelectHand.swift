//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct CardSelectHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let chooser = ctx.resolvingChooser ?? owner
        let playerObj = state.player(owner)
        let options: [CardArgOption]

        if chooser != owner {
            options = playerObj.hand.indices.map {
                CardArgOption(id: playerObj.hand[$0], label: "\(String.hiddenHand)-\($0)")
            }
        } else {
            options = playerObj.hand.toCardOptions()
        }

        return .selectable(options)
    }
}
