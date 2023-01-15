//
//  ChallengeDiscard.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// Player must choose to discard one of his card.
/// If cannot, then apply some effects
/// If the do, then apply the same effect to challenger
public struct ChallengeDiscard: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var challenger: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableIgnore private var otherwise: [Effect]
    
    public init(player: ArgPlayer, challenger: ArgPlayer, card: ArgCard, otherwise: [Effect] = []) {
        self.player = player
        self.challenger = challenger
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
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
        
        // set current player
        var ctx = ctx
        ctx.currentPlayer = playerId
        
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
                       effects: [Discard(player: PlayerId(playerId), card: CardId($0.value)),
                                 Self(player: challenger, challenger: player, card: card, otherwise: otherwise)])
            }
            choices.append(Choose(player: playerId, label: Label.pass, effects: otherwise))
            return .success(EffectOutputImpl(state: ctx, options: choices))
        }
    }
    
}
