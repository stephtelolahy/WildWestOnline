//
//  CardSelectStore.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// select any store card
public struct CardSelectStore: ArgCard, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        let cards = ctx.store.map(\.id)
        guard !cards.isEmpty else {
            return .failure(GameError.noCardInStore)
        }
        
        if cards.count == 1 {
            return .success(.identified(cards))
        }
        
        return .success(.selectable(cards.toOptions()))
    }
}
