//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct IsTimesPerTurn: PlayReqMatcherProtocol {
    let maxTimes: NumArg

    func match(state: GameState, ctx: EffectContext) -> Bool {
        guard let number = try? maxTimes.resolve(state: state, ctx: ctx) else {
            fatalError("unresolved numArg \(maxTimes)")
        }

        // No limit
        if number <= 0 {
            return true
        }

        let cardName = ctx.get(.card).extractName()
        let playedTimes = state.playCounter[cardName] ?? 0
        return playedTimes < number
    }
}
