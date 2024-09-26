//
//  EffectSteal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectSteal: EffectResolver {
    let card: ArgCard

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        guard let fromPlayerId = ctx.resolvingTarget else {
            fatalError("undefined target")
        }

        let toPlayerId = ctx.sourceActor
        var contextWithChooser = ctx
        contextWithChooser.resolvingChooser = toPlayerId
        let children = try card.resolve(.cardToSteal, state: state, ctx: contextWithChooser) {
            if state.field.hand.get(fromPlayerId).contains($0) {
                return .stealHand($0, target: fromPlayerId, player: toPlayerId)
            }
            if state.field.inPlay.get(fromPlayerId).contains($0) {
                return .stealInPlay($0, target: fromPlayerId, player: toPlayerId)
            }
            fatalError("card not found \($0)")
        }

        return .push(children)
         */
        fatalError()
    }
}
