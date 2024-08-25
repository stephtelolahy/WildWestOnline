//
//  CardEffect.swift
//  
//
//  Created by Hugues Telolahy on 30/04/2023.
//

/// Effect that can be applied to a player or a group of players
/// By default it applies to `EffectContext.actor`
/// Could set specific target(s) with `EffectContext.target`
public indirect enum CardEffect: Codable, Equatable {
    // MARK: - Actions

    /// Restore player's health, limited to maxHealth
    case heal(Int)

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int)

    /// Shoot a player
    case shoot(missesRequired: ArgNum)

    /// Prepare shoot damage effect
    case prepareShoot(missesRequired: ArgNum)

    /// Draw top deck card
    case drawDeck

    /// Discard a player's card to discard pile
    /// - `chooser` is the player that chooses card, by default `EffectContext.target`
    case discard(ArgCard, chooser: ArgPlayer? = nil)

    /// Put  back on top deck a hand card among last N
    case putBack(among: ArgNum)

    /// Reveal last hand card
    case revealLastHand

    /// Draw card from a player
    /// - the player that steals cards is `EffectContext.actor`
    /// - the player that looses a card is `EffectContext.target`
    case steal(ArgCard)

    /// Pass inPlay card to another player
    /// - `toPlayer` is the player that receives the card
    case passInPlay(ArgCard, toPlayer: ArgPlayer)

    /// Discard played card
    case discardPlayed

    /// Put played card inPlay
    case equip

    /// Put played card in target's inPlay
    case handicap

    /// Draw  cards from arena
    case drawArena

    /// Draw top discard
    case drawDiscard

    /// Draw a card from deck and put to arena
    case discover

    /// Put top deck card to discard
    case draw

    /// Start turn
    case startTurn

    /// End turn
    case endTurn

    /// Eliminate a player from the game
    case eliminate

    /// Evaluate all player attributes
    case updateAttributes

    /// Counter shoot effect
    case counterShoot

    /// Cancel turn
    case cancelTurn

    /// Expose a choice to play counter shoot cards
    case playCounterShootCards

    // MARK: - Operators

    /// Repeat an effect
    case `repeat`(ArgNum, effect: Self)

    /// Dispatch effects sequentially
    case group([Self])

    /// Apply an effect to targeted player(s)
    case target(ArgPlayer, effect: Self)

    /// Try an effect. If cannot, then apply some effect
    case force(Self, otherwise: Self)

    /// Force two players to perform an effect repeatedly. If cannot, then apply some effect
    case challenge(ArgPlayer, effect: Self, otherwise: Self)

    /// Try an effect. If cannot, then do nothing
    case ignoreError(Self)

    /// Apply effects according to just flipped card value
    case luck(ArgLuckCard, regex: String, onSuccess: Self, onFailure: Self? = nil)

    /// Runs the action matching `EffectContext.chosenOption`
    case matchAction([String: GameAction])

    /// Play ability
    case playAbility
}

public extension CardEffect {
    static let nothing: Self = .group([])

    static func group(@CardEffectsBuilder content: () -> [Self]) -> Self {
        .group(content())
    }

    func `repeat`(_ times: ArgNum) -> Self {
        .repeat(times, effect: self)
    }

    func `repeat`(_ times: Int) -> Self {
        .repeat(.exact(times), effect: self)
    }

    func target(_ target: ArgPlayer) -> Self {
        .target(target, effect: self)
    }

    func force(otherwise: Self) -> Self {
        .force(self, otherwise: otherwise)
    }

    func challenge(_ challenger: ArgPlayer, otherwise: Self) -> Self {
        .challenge(challenger, effect: self, otherwise: otherwise)
    }

    func ignoreError() -> Self {
        .ignoreError(self)
    }

    func on(_ playReqs: [PlayReq]) -> CardRule {
        .init(effect: self, playReqs: playReqs)
    }
}

@resultBuilder
public enum CardEffectsBuilder {
    public static func buildBlock(_ components: CardEffect...) -> [CardEffect] {
        components
    }
}

/// Card argument for luck effect
public enum ArgLuckCard: Codable, Equatable {
    /// Determine luck using last drawn card
    case drawn

    /// Determine luck using last drawn hand card
    case drawnHand
}
