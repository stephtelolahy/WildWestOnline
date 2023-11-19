//
//  EffectDrawArena.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDrawArena: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let card = ArgCard.selectArena
        let player = ctx.player()
        return try card.resolve(state: state, ctx: ctx) {
            switch card {
            case .selectArena:
                .drawArena($0, player: player)

            default:
                fatalError("unexpected")
            }
        }
    }
}
