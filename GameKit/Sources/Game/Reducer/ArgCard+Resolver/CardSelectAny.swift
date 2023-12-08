//
//  CardSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct CardSelectAny: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let chooser = ctx.chooser ?? owner
        let playerObj = state.player(owner)
        var options: [CardArgOption] = []

        if playerObj.inPlay.isNotEmpty {
            let inPlayOptions = playerObj.inPlay.toCardOptions()
            options.append(contentsOf: inPlayOptions)
        }

        if playerObj.hand.isNotEmpty {
            if chooser != owner {
                let randomId = playerObj.hand.randomElement().unsafelyUnwrapped
                let randomOption = CardArgOption(id: randomId, label: .randomHand)
                options.append(randomOption)
            } else {
                let handOptions = playerObj.hand.toCardOptions()
                options.append(contentsOf: handOptions)
            }
        }

        return .selectable(options)
    }
}
