//
//  ForceDiscard.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore
import ExtensionsKit

/// Player must choose to discard one of his card.
/// If cannot, then apply some effects
public struct ForceDiscard: Event, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast var card: ArgCard
    @EquatableIgnore private var otherwise: [Event]
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer, card: ArgCard, otherwise: [Event] = []) {
        self.player = player
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card, otherwise: otherwise)
            }
        }
        
        // set current target
        var childCtx: EventContext = eventCtx
        childCtx.target = playerId
        
        // resolving card
        switch card.resolve(ctx, eventCtx: eventCtx, chooser: playerId, owner: playerId) {
        case let .failure(error):
            if let gameError = error as? GameError,
                case .playerHasNoMatchingCard = gameError {
                // do not own required card
                // apply otherwise effects immediately
                return .success(EventOutputImpl(state: ctx, children: otherwise.withCtx(childCtx)))
                
            } else {
                return .failure(error)
            }
            
        case let .success(data):
            guard case let .selectable(options) = data else {
                fatalError("unexpected")
            }
            
            // request a choice:
            // - discard one of matching card
            // - or Pass
            var choices: [Choose] = options.map {
                Choose(actor: playerId,
                       label: $0.label,
                       children: [Discard(player: PlayerId(playerId), card: CardId($0.value)).withCtx(childCtx)])
            }
            choices.append(Choose(actor: playerId, label: Label.pass, children: otherwise.withCtx(childCtx)))
            return .success(EventOutputImpl(state: ctx, children: [ChooseOne(choices)]))
        }
    }
}