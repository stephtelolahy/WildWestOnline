//
//  CardSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct CardSelectAny: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let chooser = ctx.cardChooser ?? owner
        let playerObj = state.player(owner)
        var options: [CardArgOption] = []

        let inPlayOptions = playerObj.inPlay.toCardOptions()
        options.append(contentsOf: inPlayOptions)

        if chooser != owner {
            let handOptions = playerObj.hand.indices.map {
                CardArgOption(id: playerObj.hand[$0], label: "\(String.hiddenHand)-\($0)")
            }
            options.append(contentsOf: handOptions)
        } else {
            let handOptions = playerObj.hand.toCardOptions()
            options.append(contentsOf: handOptions)
        }

        return .selectable(options)
    }
}
