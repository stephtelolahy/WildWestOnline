//
//  Steal.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable function_default_parameter_at_end
import GameRules

/// draw card from other player
public struct Steal: Event, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var target: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer = PlayerActor(), target: ArgPlayer, card: ArgCard) {
        self.player = player
        self.target = target
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), target: target, card: card)
            }
        }
        
        guard let targetId = (target as? PlayerId)?.id else {
            return resolve(target, ctx: ctx) {
                Self(player: player, target: PlayerId($0), card: card)
            }
        }
        
        guard let cardId = (card as? CardId)?.id else {
            return resolve(card, ctx: ctx, chooser: playerId, owner: targetId) {
                Self(player: player, target: target, card: CardId($0))
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        var targetObj = ctx.player(targetId)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == cardId }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            playerObj.hand.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == cardId }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            playerObj.hand.append(cardObj)
        }
        
        ctx.players[playerId] = playerObj
        ctx.players[targetId] = targetObj
        
        return .success(EventOutputImpl(state: ctx))
    }
}
