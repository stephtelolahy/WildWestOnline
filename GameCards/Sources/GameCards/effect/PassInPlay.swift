//
//  PassInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameCore
import ExtensionsKit

struct PassInPlay: Event, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableCast private var target: ArgPlayer
    @EquatableIgnore var eventCtx: EventContext = EventContextImpl()
    
    // swiftlint:disable:next function_default_parameter_at_end
    init(player: ArgPlayer = PlayerActor(), card: ArgCard, target: ArgPlayer) {
        self.player = player
        self.card = card
        self.target = target
    }
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card, target: target)
            }
        }
        
        guard let cardId = (card as? CardId)?.id else {
            return resolve(card, ctx: ctx, chooser: playerId, owner: playerId) {
                Self(player: player, card: CardId($0), target: target)
            }
        }
        
        guard let targetId = (target as? PlayerId)?.id else {
            return resolve(target, ctx: ctx) {
                Self(player: player, card: card, target: PlayerId($0))
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        var targetObj = ctx.player(targetId)
        
        guard let inPlayIndex = playerObj.inPlay.firstIndex(where: { $0.id == cardId }) else {
            fatalError(InternalError.missingPlayerCard(cardId))
        }

        let cardObj = playerObj.inPlay.remove(at: inPlayIndex)
        targetObj.inPlay.append(cardObj)
        ctx.players[playerId] = playerObj
        ctx.players[targetId] = targetObj
        
        return .success(EventOutputImpl(state: ctx))
    }
}
