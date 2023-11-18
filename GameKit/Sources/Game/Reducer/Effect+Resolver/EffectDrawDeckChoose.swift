//
//  EffectDrawDeckChoose.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//

struct EffectDrawDeckChoose: EffectResolver {
    let amount: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.player()
        let count = try amount.resolve(state: state, ctx: ctx)
        guard count >= 1 else {
            return []
        }

        var state = state
        var topCards: [String] = []
        for _ in (0...count) {
            #warning("incoherent deck")
            let card = try state.popDeck()
            topCards.append(card)
        }

        let options = topCards.reduce(into: [String: GameAction]()) {
            $0[$1] = .drawDeckChoose($1, player: player)
        }

        let chooseOne = GameAction.chooseOne(
            player: player,
            options: options
        )

        var result: [GameAction] = []
        result.append(chooseOne)

        let remainingCards = count - 1
        if remainingCards >= 1 {
            result.append(.effect(.drawDeckChoose(.exact(remainingCards)), ctx: ctx))
        }

        return result
    }
}
