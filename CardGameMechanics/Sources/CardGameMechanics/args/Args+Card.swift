//
//  Args+Card.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Effect's card argument of a player
public extension Args {
    
    /// random hand card
    static let cardRandomHand = "CARD_RANDOM_HAND"
    
    /// all cards
    static let cardAll = "CARD_ALL"
    
    /// select any card
    static let cardSelectAny = "CARD_SELECT_ANY"
    
    /// select a hand card
    static let cardSelectHand = "CARD_SELECT_HAND"
}

extension Args {
    
    // swiftlint:disable function_parameter_count
    static func resolveCard<T: Effect>(
        _ card: String,
        copyWithCard: @escaping (String) -> T,
        source: EffectCardSource,
        ctx: State,
        actor: String,
        selectedArg: String?
    ) -> EffectResult {
        switch resolveCard(card, source: source, ctx: ctx, actor: actor) {
            
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let effects = cIds.map { copyWithCard($0) }
                return .resolving(effects)
                
            case let .selectable(cIds):
                if let selectedId = selectedArg,
                   cIds.contains(selectedId) {
                    let copy = copyWithCard(selectedId)
                    return .resolving([copy])
                } else {
                    let options = cIds.map { Choose(value: $0, actor: actor) }
                    return .suspended([actor: options])
                }
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func isCardResolved(_ card: String, source: EffectCardSource, ctx: State) -> Bool {
        switch source {
        case let .player(pId):
            let playerObj = ctx.player(pId)
            return (playerObj.hand + playerObj.inPlay).contains { $0.id == card }
            
        case .store:
            return ctx.store.contains { $0.id == card }
        }
    }
    
    enum EffectCardSource {
        case player(String)
        case store
    }
    
    enum EffectCardResolved {
        case identified([String])
        case selectable([String])
    }
    
    static func resolveCard(
        _ card: String,
        source: EffectCardSource,
        ctx: State,
        actor: String
    ) -> Result<EffectCardResolved, Error> {
        switch card {
        case cardRandomHand:
            return resolveRandomHand(source: source, ctx: ctx)
            
        case cardAll:
            return resolveAll(source: source, ctx: ctx)
            
        case cardSelectAny:
            return resolveSelectAny(source: source, actor: actor, ctx: ctx)
            
        case cardSelectHand:
            return resolveSelectHand(source: source, actor: actor, ctx: ctx)
            
        default:
            /// assume identified card
            guard isCardResolved(card, source: source, ctx: ctx) else {
                fatalError(.cardValueInvalid(card))
            }
            
            return .success(.identified([card]))
        }
    }
}

private extension Args {
    
    static func resolveRandomHand(source: EffectCardSource, ctx: State) -> Result<EffectCardResolved, Error> {
        guard case let .player(pId) = source else {
            fatalError(.cardSourceInvalid)
        }
        
        let playerObj = ctx.player(pId)
        guard !playerObj.hand.isEmpty,
              let randId = playerObj.hand.map({ $0.id }).randomElement() else {
            return .failure(ErrorPlayerHasNoCard(player: pId))
        }
        
        return .success(.identified([randId]))
    }
    
    static func resolveAll(source: EffectCardSource, ctx: State) -> Result<EffectCardResolved, Error> {
        guard case let .player(pId) = source else {
            fatalError(.cardSourceInvalid)
        }
        
        let playerObj = ctx.player(pId)
        let all = (playerObj.inPlay + playerObj.hand).map { $0.id }
        guard !all.isEmpty else {
            return .failure(ErrorPlayerHasNoCard(player: pId))
        }
        
        return .success(.identified(all))
    }
    
    static func resolveSelectAny(source: EffectCardSource, actor: String, ctx: State) -> Result<EffectCardResolved, Error> {
        // setup options
        switch source {
        case let .player(pId):
            let playerObj = ctx.player(pId)
            if playerObj.inPlay.isEmpty {
                // random hand
                if !playerObj.hand.isEmpty,
                   let randId = playerObj.hand.map({ $0.id }).randomElement() {
                    return .success(.identified([randId]))
                } else {
                    return .failure(ErrorPlayerHasNoCard(player: pId))
                }
            } else {
                // select inPlay
                var cards = playerObj.inPlay.map { $0.id }
                if !playerObj.hand.isEmpty {
                    cards.append(Args.cardRandomHand)
                }
                return .success(.selectable(cards))
            }
            
        case .store:
            let cards = ctx.store.map { $0.id }
            guard !cards.isEmpty else {
                return .failure(ErrorStoreHasNoCard())
            }
            
            if cards.count == 1 {
                return .success(.identified(cards))
            }
            
            return .success(.selectable(cards))
        }
    }
    
    static func resolveSelectHand(source: EffectCardSource, actor: String, ctx: State) -> Result<EffectCardResolved, Error> {
        guard case let .player(pId) = source else {
            fatalError(.cardSourceInvalid)
        }
        
        let playerObj = ctx.player(pId)
        let cards = playerObj.hand.map { $0.id }
        guard !cards.isEmpty else {
            return .failure(ErrorPlayerHasNoCard(player: pId))
        }
        
        return .success(.selectable(cards))
    }
}
