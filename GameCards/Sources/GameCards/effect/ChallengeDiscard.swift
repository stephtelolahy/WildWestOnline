//
//  ChallengeDiscard.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
import GameCore
import ExtensionsKit

/// Player must choose to discard one of his card.
/// If cannot, then apply some effects
/// If the do, then apply the same effect to challenger
public struct ChallengeDiscard: Event, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var challenger: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableIgnore private var otherwise: [Event]
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer, challenger: ArgPlayer, card: ArgCard, otherwise: [Event] = []) {
        self.player = player
        self.challenger = challenger
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), challenger: challenger, card: card, otherwise: otherwise)
            }
        }
        
        guard challenger is PlayerId else {
            return resolve(challenger, ctx: ctx) {
                Self(player: player, challenger: PlayerId($0), card: card, otherwise: otherwise)
            }
        }
        
        // set current target
        var eventCtx = eventCtx
        eventCtx.target = playerId
        
        // resolving card
        switch card.resolve(ctx, eventCtx: eventCtx, chooser: playerId, owner: playerId) {
        case let .failure(error):
            if let gameError = error as? GameError,
                case .playerHasNoMatchingCard = gameError {
                // do not own required card
                // apply otherwise effects immediately
                return .success(EventOutputImpl(state: ctx, children: otherwise.withCtx(eventCtx)))
                
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
                       children: [Discard(player: PlayerId(playerId), card: CardId($0.value)).withCtx(eventCtx),
                                  Self(player: challenger, challenger: player, card: card, otherwise: otherwise).withCtx(eventCtx)])
            }
            choices.append(Choose(actor: playerId, label: Label.pass, children: otherwise.withCtx(eventCtx)))
            return .success(EventOutputImpl(state: ctx, children: [ChooseOne(choices)]))
        }
    }
    
}