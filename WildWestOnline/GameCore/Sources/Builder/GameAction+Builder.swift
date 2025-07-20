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
            player: player,
            playedCard: playedCard
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            name: .choose,
            player: player,
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

    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            name: .damage,
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
            player: player,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .stealInPlay,
            player: player,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func passInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .passInPlay,
            player: player,
            targetedPlayer: target,
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

    static func endGame(player: String) -> Self {
        .init(
            name: .endGame,
            targetedPlayer: player
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
            player: player,
            playedCard: playedCard,
            targetedPlayer: target,
            targetedCard: card
        )
    }

    static func equip(_ playedCard: String, player: String) -> Self {
        .init(
            name: .equip,
            player: player,
            playedCard: playedCard
        )
    }

    static func handicap(_ playedCard: String, target: String, player: String) -> Self {
        .init(
            name: .handicap,
            player: player,
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

    static func setPlayLimitPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            name: .setPlayLimitPerTurn,
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

    static var dummy: Self {
        .init(
            name: .queue,
            nestedEffects: []
        )
    }
}
