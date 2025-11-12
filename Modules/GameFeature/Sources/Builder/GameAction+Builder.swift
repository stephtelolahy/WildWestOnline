//
//  GameAction+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension GameFeature.Action {
    static func preparePlay(_ playedCard: String, player: String) -> Self {
        .init(
            name: .preparePlay,
            sourcePlayer: player,
            playedCard: playedCard
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            name: .choose,
            targetedPlayer: player,
            chosenOption: selection
        )
    }

    static func draw() -> Self {
        .init(
            name: .draw
        )
    }

    static func drawDeck(player: String) -> Self {
        .init(
            name: .drawDeck,
            targetedPlayer: player
        )
    }

    static func drawDiscard(player: String) -> Self {
        .init(
            name: .drawDiscard,
            targetedPlayer: player
        )
    }

    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            name: .drawDiscovered,
            targetedPlayer: player,
            targetedCard: card
        )
    }

    static func discover() -> Self {
        .init(
            name: .discover
        )
    }

    static func heal(_ amount: Int, player: String) -> Self {
        .init(
            name: .heal,
            targetedPlayer: player,
            amount: amount
        )
    }

    static func damage(_ amount: Int, player: String, sourcePlayer: String = "") -> Self {
        .init(
            name: .damage,
            sourcePlayer: sourcePlayer,
            targetedPlayer: player,
            amount: amount
        )
    }

    static func discardHand(_ card: String, player: String) -> Self {
        .init(
            name: .discardHand,
            targetedPlayer: player,
            targetedCard: card
        )
    }

    static func discardInPlay(_ card: String, player: String) -> Self {
        .init(
            name: .discardInPlay,
            targetedPlayer: player,
            targetedCard: card
        )
    }

    static func stealHand(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .stealHand,
            sourcePlayer: player,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .stealInPlay,
            sourcePlayer: player,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func passInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .passInPlay,
            sourcePlayer: player,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func showHand(_ card: String, player: String) -> Self {
        .init(
            name: .showHand,
            targetedPlayer: player,
            targetedCard: card
        )
    }

    static func shoot(_ target: String) -> Self {
        .init(
            name: .shoot,
            targetedPlayer: target
        )
    }

    static func counterShoot(player: String) -> Self {
        .init(
            name: .counterShot,
            targetedPlayer: player
        )
    }

    static func startTurn(player: String) -> Self {
        .init(
            name: .startTurn,
            targetedPlayer: player
        )
    }

    static func endTurn(player: String) -> Self {
        .init(
            name: .endTurn,
            targetedPlayer: player
        )
    }

    static func eliminate(player: String) -> Self {
        .init(
            name: .eliminate,
            targetedPlayer: player
        )
    }

    static func endGame() -> Self {
        .init(
            name: .endGame
        )
    }

    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            name: .activate,
            targetedPlayer: player,
            affectedCards: cards
        )
    }

    static func play(_ playedCard: String, player: String, target: String? = nil, card: String? = nil) -> Self {
        .init(
            name: .play,
            sourcePlayer: player,
            playedCard: playedCard,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func equip(_ playedCard: String, player: String) -> Self {
        .init(
            name: .equip,
            sourcePlayer: player,
            playedCard: playedCard
        )
    }

    static func handicap(_ playedCard: String, target: String, player: String) -> Self {
        .init(
            name: .handicap,
            sourcePlayer: player,
            playedCard: playedCard,
            targetedPlayer: target
        )
    }

    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            name: .setWeapon,
            targetedPlayer: player,
            amount: weapon
        )
    }

    static func setPlayLimitsPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            name: .setPlayLimitsPerTurn,
            targetedPlayer: player,
            amountPerTurn: limit
        )
    }

    static func increaseMagnifying(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseMagnifying,
            targetedPlayer: player,
            amount: amount
        )
    }

    static func increaseRemoteness(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseRemoteness,
            targetedPlayer: player,
            amount: amount
        )
    }

    static func increaseCardsToDrawThisTurn(_ amount: Int) -> Self {
        .init(
            name: .increaseCardsToDrawThisTurn,
            amount: amount
        )
    }

    static var dummy: Self {
        .init(
            name: .queue,
            nestedEffects: []
        )
    }
}
