//
//  CardSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct CardSelectAny: ArgCardResolver {
    func resolve(state: GameState, ctx: ArgCardContext) -> CardArgOutput {
        let playerObj = state.player(ctx.owner)
        var options: [CardArgOption] = []

        if playerObj.inPlay.cards.isNotEmpty {
            let inPlayOptions = playerObj.inPlay.cards.toCardOptions()
            options.append(contentsOf: inPlayOptions)
        }

        if playerObj.hand.cards.isNotEmpty {
            if ctx.chooser != ctx.owner {
                let randomId = playerObj.hand.cards.randomElement().unsafelyUnwrapped
                let randomOption = CardArgOption(id: randomId, label: .randomHand)
                options.append(randomOption)
            } else {
                let handOptions = playerObj.hand.cards.toCardOptions()
                options.append(contentsOf: handOptions)
            }
        }

        return .selectable(options)
    }
}