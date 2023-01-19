//
//  OnForceDiscardHandNamed.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

public struct OnForceDiscardHandNamed: PlayReq, Equatable {
    private let cardName: String
    
    public init(_ cardName: String) {
        self.cardName = cardName
    }
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard case let .success(event) = ctx.event,
              let forceDiscard = event as? ForceDiscard,
              let selectHandNamed = forceDiscard.card as? CardSelectHandNamed,
              selectHandNamed.name == cardName else {
            return .failure(.unknown)
        }
        return  .success
    }
}
