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
            payload: .init(
                player: player,
                playedCard: playedCard
            )
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            name: .choose,
            payload: .init(
                player: player,
                selection: selection
            )
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
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func drawDiscard(player: String) -> Self {
        .init(
            name: .drawDiscard,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            name: .drawDiscovered,
            payload: .init(
                targetedPlayer: player,
                targetedCard: card
            )
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
            payload: .init(
                targetedPlayer: player,
                amount: amount
            )
        )
    }

    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            name: .damage,
            payload: .init(
                targetedPlayer: player,
                amount: amount
            )
        )
    }

    static func discardHand(_ card: String, player: String) -> Self {
        .init(
            name: .discardHand,
            payload: .init(
                targetedPlayer: player,
                targetedCard: card
            )
        )
    }

    static func discardInPlay(_ card: String, player: String) -> Self {
        .init(
            name: .discardInPlay,
            payload: .init(
                targetedPlayer: player,
                targetedCard: card
            )
        )
    }

    static func stealHand(_ card: String, target: String, player: String, source: String = "") -> Self {
        .init(
            name: .stealHand,
            payload: .init(
                player: player,
                playedCard: source,
                targetedPlayer: target,
                targetedCard: card
            )
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String, source: String = "") -> Self {
        .init(
            name: .stealInPlay,
            payload: .init(
                player: player,
                playedCard: source,
                targetedPlayer: target,
                targetedCard: card
            )
        )
    }

    static func passInPlay(_ card: String, target: String, player: String, source: String = "") -> Self {
        .init(
            name: .passInPlay,
            payload: .init(
                player: player,
                playedCard: source,
                targetedPlayer: target,
                targetedCard: card
            )
        )
    }

    static func shoot(_ target: String) -> Self {
        .init(
            name: .shoot,
            payload: .init(
                targetedPlayer: target
            )
        )
    }

    static func counterShoot(player: String) -> Self {
        .init(
            name: .counterShot,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func startTurn(player: String) -> Self {
        .init(
            name: .startTurn,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func endTurn(player: String) -> Self {
        .init(
            name: .endTurn,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func eliminate(player: String) -> Self {
        .init(
            name: .eliminate,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func endGame(player: String) -> Self {
        .init(
            name: .endGame,
            payload: .init(
                targetedPlayer: player
            )
        )
    }

    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            name: .activate,
            payload: .init(
                targetedPlayer: player,
                cards: cards
            )
        )
    }

    static func play(_ playedCard: String, player: String, target: String? = nil, card: String? = nil) -> Self {
        .init(
            name: .play,
            payload: .init(
                player: player,
                playedCard: playedCard,
                targetedPlayer: target,
                targetedCard: card
            )
        )
    }

    static func equip(_ playedCard: String, player: String) -> Self {
        .init(
            name: .equip,
            payload: .init(
                player: player,
                playedCard: playedCard
            )
        )
    }

    static func handicap(_ playedCard: String, target: String, player: String) -> Self {
        .init(
            name: .handicap,
            payload: .init(
                player: player,
                playedCard: playedCard,
                targetedPlayer: target
            )
        )
    }

    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            name: .setWeapon,
            payload: .init(
                targetedPlayer: player,
                amount: weapon
            )
        )
    }

    static func setPlayLimitPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            name: .setPlayLimitPerTurn,
            payload: .init(
                targetedPlayer: player,
                amountPerTurn: limit
            )
        )
    }

    static func increaseMagnifying(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseMagnifying,
            payload: .init(
                targetedPlayer: player,
                amount: amount
            )
        )
    }

    static func increaseRemoteness(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseRemoteness,
            payload: .init(
                targetedPlayer: player,
                amount: amount
            )
        )
    }

    static var dummy: Self {
        .init(
            name: .queue,
            payload: .init(
                nestedEffects: []
            )
        )
    }
}
