//
//  ForceDiscard.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Player must choose to discard one of his card.
/// If cannot, then apply some effects
public struct ForceDiscard: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast var card: ArgCard
    @EquatableIgnore private var otherwise: [Effect]
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init(player: ArgPlayer, card: ArgCard, otherwise: [Effect] = []) {
        self.player = player
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card, otherwise: otherwise)
            }
        }
        
        // set current target
        var childCtx: PlayContext = playCtx
        childCtx.target = playerId
        
        // resolving card
        switch card.resolve(ctx, playCtx: playCtx, chooser: playerId, owner: playerId) {
        case let .failure(error):
            if case .playerHasNoMatchingCard = error {
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
