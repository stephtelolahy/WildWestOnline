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
            fatalError("unexpected")
        }

        guard state.deck.count > count else {
            return (0..<count).map { _ in
                    .drawDeck(player: player)
            }
        }

        let topCards = Array(state.deck.cards.prefix(count + 1))
        let options = topCards.reduce(into: [String: GameAction]()) {
            $0[$1] = .drawDeckChoose($1, player: player)
        }

        let chooseOne = try GameAction.validateChooseOne(
            chooser: player,
            options: options,
            state: state
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
