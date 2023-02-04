//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// select any hand card
public struct CardSelectHand: ArgCard, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        guard let playerId = owner else {
            fatalError(InternalError.missingCardOwner)
        }
        
        let playerObj = ctx.player(playerId)
        var options: [ArgOption] = []
        
        if !playerObj.hand.isEmpty {
            if chooser != owner {
                // swiftlint:disable:next force_unwrapping
                let randomId = playerObj.hand.map(\.id).randomElement()!
                let randomOption = ArgOptionImpl(value: randomId, label: Label.randomHand)
                options.append(randomOption)
            } else {
                let handOptions = playerObj.hand.map(\.id).toOptions()
                options.append(contentsOf: handOptions)
            }
        }
        
        guard !options.isEmpty else {
            return .failure(GameError.playerHasNoHandCard(playerId))
        }
        
        return .success(.selectable(options))
    }
}
