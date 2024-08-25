//
//  EffectDiscard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDiscard: EffectResolver {
    let card: ArgCard
    let chooser: ArgPlayer?

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        let player = ctx.targetOrActor()
        var contextWithChooser = ctx
        if let chooser {
            contextWithChooser.resolvingChooser = try chooser.resolveUnique(state: state, ctx: ctx)
        }
        let children = try card.resolve(.cardToDiscard, state: state, ctx: contextWithChooser) {
            if state.field.hand.get(player).contains($0) {
                return .discardHand($0, player: player)
            }
            if state.field.inPlay.get(player).contains($0) {
                return .discardInPlay($0, player: player)
            }
            fatalError("card not found \($0)")
        }

        return .push(children)
    }
}
