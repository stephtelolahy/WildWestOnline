//
//  CardSelectHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 16/04/2023.
//

struct CardSelectHandNamed: ArgCardResolver {
    let name: String

    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let playerObj = state.player(owner)
        let options = playerObj.hand
            .filter { $0.extractName() == name }
            .toCardOptions()

        return .selectable(options)
    }
}
