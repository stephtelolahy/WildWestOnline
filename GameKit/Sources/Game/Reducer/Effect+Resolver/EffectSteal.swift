//
//  EffectSteal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectSteal: EffectResolver {
    let card: ArgCard
    let toPlayer: ArgPlayer
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let fromPlayerId = ctx.target!
        let toPlayerId = try toPlayer.resolveUnique(state: state, ctx: ctx)
        var chooserContext = ctx
        chooserContext.chooser = toPlayerId
        return try card.resolve(state: state, ctx: chooserContext) {
            if state.player(fromPlayerId).hand.contains($0) {
                return .stealHand($0, target: fromPlayerId, player: toPlayerId)
            }
            if state.player(fromPlayerId).inPlay.contains($0) {
                return .stealInPlay($0, target: fromPlayerId, player: toPlayerId)
            }
            fatalError("card not found \($0)")
        }
    }
}
