//
//  NumShootMissesRequired.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 26/05/2024.
//

struct NumShootMissesRequired: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        guard case let .prepareEffect(effect, ctx: effectCtx) = ctx.sourceEvent,
                case .shoot(let missesRequired) = effect else {
            fatalError("unexpectd")
        }

        return try missesRequired.resolve(state: state, ctx: effectCtx)
    }
}
