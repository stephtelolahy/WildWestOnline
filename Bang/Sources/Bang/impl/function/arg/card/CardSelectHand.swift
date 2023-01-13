//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// select any hand card
public struct CardSelectHand: ArgCard, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        guard let playerId = owner else {
            fatalError(.missingCardOwner)
        }
        
        let playerObj = ctx.player(playerId)
        var options: [ArgResolved.Option] = []
        
        if !playerObj.hand.isEmpty {
            if chooser != owner {
                // swiftlint:disable:next force_unwrapping
                let randomId = playerObj.hand.map(\.id).randomElement()!
                let randomOption = ArgResolved.Option(value: randomId, label: Label.randomHand)
                options.append(randomOption)
            } else {
                let handOptions = playerObj.hand.map(\.id).toOptions()
                options.append(contentsOf: handOptions)
            }
        }
        
        guard !options.isEmpty else {
            return .failure(.playerHasNoHandCard(playerId))
        }
        
        return .success(.selectable(options))
    }
}
