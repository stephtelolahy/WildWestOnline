//
//  CardSelectHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// select any self's hand card matching given name
/// chooser is owner
public struct CardSelectHandNamed: ArgCard, Equatable {
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }

    public func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        let playerObj = ctx.player(chooser)
        let matchingCards = playerObj.hand.filter { $0.name == name }.map(\.id)
        guard !matchingCards.isEmpty else {
            return .failure(GameError.playerHasNoMatchingCard(chooser))
        }
        
        return .success(.selectable(matchingCards.toOptions()))
    }
}
