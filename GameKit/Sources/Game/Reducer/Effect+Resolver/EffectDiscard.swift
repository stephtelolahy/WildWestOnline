//
//  EffectDiscard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDiscard: EffectResolverProtocol {
    let card: CardArg
    let chooser: PlayerArg?
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let owner = ctx.get(.target)
        var chooserId = owner
        if let chooser {
            chooserId = try chooser.resolveUnique(state: state, ctx: ctx)
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