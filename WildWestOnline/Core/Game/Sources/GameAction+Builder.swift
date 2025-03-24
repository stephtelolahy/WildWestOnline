//
//  GameAction+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension GameAction {
    static func preparePlay(_ card: String, player: String) -> Self {
        .init(
            name: .preparePlay,
            payload: .init(
                player: player,
                played: card
            )
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            name: .choose,
            payload: .init(
                player: player,
                played: "",
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
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func drawDiscard(player: String) -> Self {
        .init(
            name: .drawDiscard,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            name: .drawDiscovered,
            payload: .init(
                player: "",
                played: "",
                target: player,
                card: card
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
                player: "",
                played: "",
                target: player,
                amount: amount
            )
        )
    }

    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            name: .damage,
            payload: .init(
                player: "",
                played: "",
                target: player,
                amount: amount
            )
        )
    }

    static func discardHand(_ card: String, player: String) -> Self {
        .init(
            name: .discardHand,
            payload: .init(
                player: "",
                played: "",
                target: player,
                card: card
            )
        )
    }

    static func discardInPlay(_ card: String, player: String) -> Self {
        .init(
            name: .discardInPlay,
            payload: .init(
                player: "",
                played: "",
                target: player,
                card: card
            )
        )
    }

    static func stealHand(_ card: String, target: String, player: String, source: String) -> Self {
        .init(
            name: .stealHand,
            payload: .init(
                player: player,
                played: source,
                target: target,
                card: card
            )
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .stealInPlay,
            payload: .init(
                player: player,
                played: "",
                target: target,
                card: card
            )
        )
    }

    static func passInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .passInPlay,
            payload: .init(
                player: player,
                played: "",
                target: target,
                card: card
            )
        )
    }

    static func shoot(_ target: String) -> Self {
        .init(
            name: .shoot,
            payload: .init(
                player: "",
                played: "",
                target: target
            )
        )
    }

    static func counterShoot(player: String) -> Self {
        .init(
            name: .counterShot,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func startTurn(player: String) -> Self {
        .init(
            name: .startTurn,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func endTurn(player: String) -> Self {
        .init(
            name: .endTurn,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func eliminate(player: String) -> Self {
        .init(
            name: .eliminate,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func endGame(player: String) -> Self {
        .init(
            name: .endGame,
            payload: .init(
                player: "",
                played: "",
                target: player
            )
        )
    }

    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            name: .activate,
            payload: .init(
                player: "",
                played: "",
                target: player,
                cards: cards
            )
        )
    }

    static func play(_ card: String, player: String) -> Self {
        .init(
            name: .play,
            payload: .init(
                player: player,
                played: card
            )
        )
    }

    static func equip(_ card: String, player: String) -> Self {
        .init(
            name: .equip,
            payload: .init(
                player: player,
                played: card
            )
        )
    }

    static func handicap(_ card: String, target: String, player: String) -> Self {
        .init(
            name: .handicap,
            payload: .init(
                player: player,
                played: card,
                target: target
            )
        )
    }

    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            name: .setWeapon,
            payload: .init(
                player: "",
                played: "",
                target: player,
                amount: weapon
            )
        )
    }

    static func setPlayLimitPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            name: .setPlayLimitPerTurn,
            payload: .init(
                player: "",
                played: "",
                target: player,
                amountPerCard: limit
            )
        )
    }

    static func increaseMagnifying(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseMagnifying,
            payload: .init(
                player: "",
                played: "",
                target: player,
                amount: amount
            )
        )
    }

    static func increaseRemoteness(_ amount: Int, player: String) -> Self {
        .init(
            name: .increaseRemoteness,
            payload: .init(
                player: "",
                played: "",
                target: player,
                amount: amount
            )
        )
    }

    static var dummy: Self {
        .init(
            name: .queue,
            payload: .init(
                player: "",
                played: "",
                children: []
            )
        )
    }
}
