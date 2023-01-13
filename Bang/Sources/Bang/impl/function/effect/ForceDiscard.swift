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
    @EquatableCast private var card: ArgCard
    @EquatableIgnore private var otherwise: [Effect]
    
    public init(player: ArgPlayer, card: ArgCard, otherwise: [Effect] = []) {
        self.player = player
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card, otherwise: otherwise)
            }
        }
        
        // add current player to queue data
        var ctx = ctx
        ctx.queuePlayer = playerId
        
        // resolving card
        switch card.resolve(ctx, chooser: playerId, owner: playerId) {
        case let .failure(error):
            if case .playerHasNoMatchingCard = error {
                // do not own required card
                // apply otherwise effects immediately
                return .success(EffectOutputImpl(state: ctx, effects: otherwise))
                
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
            var choices: [Effect] = options.map {
                Choose(player: playerId,
                       label: $0.label,
                       effects: [Discard(player: PlayerId(playerId), card: CardId($0.value))])
            }
            choices.append(Choose(player: playerId,
                                  label: Label.pass,
                                  effects: otherwise))
            return .success(EffectOutputImpl(state: ctx, options: choices))
        }
    }
}
