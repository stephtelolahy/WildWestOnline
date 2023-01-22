//
//  OnForceDiscardHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

struct OnForceDiscardHandNamed: PlayReq, Equatable {
    private let cardName: String
    
    init(_ cardName: String) {
        self.cardName = cardName
    }
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard case let .success(event) = ctx.event,
              let forceDiscard = event as? ForceDiscard,
              let selectHandNamed = forceDiscard.card as? CardSelectHandNamed,
              selectHandNamed.name == cardName else {
            return .failure(GameError.unknown)
        }
        return  .success
    }
}
