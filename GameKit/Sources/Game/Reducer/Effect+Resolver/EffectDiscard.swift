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
        let owner = ctx.get(.target)
        var chooserId = owner
        if let chooser {
            let playerContext = ArgPlayerContext(actor: ctx.get(.actor))
            chooserId = try chooser.resolveUnique(state: state, ctx: playerContext)
        }

        return try card.resolve(state: state, ctx: ctx, chooser: chooserId, owner: owner) {
            if state.player(owner).hand.contains($0) {
                return .discardHand($0, player: owner)
            }
            if state.player(owner).inPlay.contains($0) {
                return .discardInPlay($0, player: owner)
            }
            fatalError("card not found \($0)")
        }
    }
}
