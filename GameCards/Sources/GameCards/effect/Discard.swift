//
//  Discard.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable function_default_parameter_at_end
import GameCore
import ExtensionsKit

/// Discard a player's card to discard pile
/// Actor is the card chooser
public struct Discard: Event, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer = PlayerActor(), card: ArgCard) {
        self.player = player
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card)
            }
        }
        
        guard let cardId = (card as? CardId)?.id else {
            return resolve(card, ctx: ctx, chooser: eventCtx.actor, owner: playerId) {
                Self(player: player, card: CardId($0))
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == cardId }) {
            let cardObj = playerObj.hand.remove(at: handIndex)
            ctx.discard.append(cardObj)
        }
        
        if let inPlayIndex = playerObj.inPlay.firstIndex(where: { $0.id == cardId }) {
            let cardObj = playerObj.inPlay.remove(at: inPlayIndex)
            ctx.discard.append(cardObj)
        }
        
        ctx.players[playerId] = playerObj
        
        return .success(EventOutputImpl(state: ctx))
    }
}