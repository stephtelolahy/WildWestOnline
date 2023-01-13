//
//  CardSelectHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// select any self's hand card matching given name
/// chooser is owner
public struct CardSelectHandNamed: ArgCard, Equatable {
    private let name: String
    
    public init(_ name: String) {
        self.name = name
    }

    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        let playerObj = ctx.player(chooser)
        let matchingCards = playerObj.hand.filter { $0.name == name }.map(\.id)
        guard !matchingCards.isEmpty else {
            return .failure(.playerHasNoMatchingCard(chooser))
        }
        
        return .success(.selectable(matchingCards.toOptions()))
    }
}
