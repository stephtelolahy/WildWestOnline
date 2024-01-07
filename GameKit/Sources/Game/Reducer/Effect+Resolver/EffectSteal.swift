//
//  EffectSteal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectSteal: EffectResolver {
    let card: ArgCard

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let fromPlayerId = ctx.target else {
            fatalError("undefined target")
        }

        let toPlayerId = ctx.actor
        var contextWithChooser = ctx
        contextWithChooser.chooser = toPlayerId
        return try card.resolve(state: state, ctx: contextWithChooser) {
            if state.player(fromPlayerId).hand.contains($0) {
                return .drawHand($0, target: fromPlayerId, player: toPlayerId)
            }
            if state.player(fromPlayerId).inPlay.contains($0) {
                return .drawInPlay($0, target: fromPlayerId, player: toPlayerId)
            }
            fatalError("card not found \($0)")
        }
    }
}
