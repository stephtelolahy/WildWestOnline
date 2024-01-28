//
//  CardRandomHand.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

struct CardRandomHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let playerObj = state.player(owner)
        let options = playerObj.hand.indices.map {
            CardArgOption(id: playerObj.hand[$0], label: "\(String.hiddenHand)-\($0)")
        }
        return .selectable(options)
    }
}
