//
//  Draw.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Draw a card from top deck
public struct Draw: Effect, Equatable {
    
    private let player: ArgPlayer
    
    public init(player: ArgPlayer) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .id(playerId) = player else {
            return ArgResolverPlayer.resolve(player, ctx: ctx) {
                Draw(player: .id($0))
            }
        }
        
        var playerObj = ctx.player(playerId)
        var ctx = ctx
        let card = ctx.removeTopDeck()
        playerObj.hand.append(card)
        ctx.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}

private extension Game {
    
    /// Remove top deck card
    mutating func removeTopDeck() -> Card {
        // reseting deck if empty
        if deck.isEmpty,
           discard.count >= 2 {
            let cards = discard
            deck.append(contentsOf: cards.dropLast().shuffled())
            discard = cards.suffix(1)
        }
        
        return deck.removeFirst()
    }
}

