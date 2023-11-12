//
//  EffectChooseCard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectChooseCard: EffectResolver {
    let card: ArgCard

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.player()
        return try card.resolve(state: state, ctx: ctx) {
            switch card {
            case .selectArena:
                .chooseArena($0, player: player)
            default:
                fatalError("unexpected")
            }
        }
    }
}
