//
//  EffectDiscard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDiscard: EffectResolver {
    let card: ArgCard
    let chooser: ArgPlayer?
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.target!
        var chooserContext = ctx
        if let chooser {
            chooserContext.chooser = try chooser.resolveUnique(state: state, ctx: chooserContext)
        }
        return try card.resolve(state: state, ctx: chooserContext) {
            if state.player(player).hand.contains($0) {
                return .discardHand($0, player: player)
            }
            if state.player(player).inPlay.contains($0) {
                return .discardInPlay($0, player: player)
            }
            fatalError("card not found \($0)")
        }
    }
}
