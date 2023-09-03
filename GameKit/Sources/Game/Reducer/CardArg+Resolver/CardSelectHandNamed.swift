//
//  CardSelectHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 16/04/2023.
//

struct CardSelectHandNamed: CardArgResolverProtocol {
    let name: String

    func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?
    ) -> CardArgOutput {
        guard let owner else {
            fatalError("unexpected")
        }

        let playerObj = state.player(owner)
        let options = playerObj.hand.cards
            .filter { $0.extractName() == name }
            .toCardOptions()

        return .selectable(options)
    }
}
