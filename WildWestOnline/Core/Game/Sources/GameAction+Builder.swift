//
//  GameAction+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension GameAction {
    static func preparePlay(_ card: String, player: String) -> Self {
        .init(
            kind: .preparePlay,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            kind: .choose,
            payload: .init(
                target: player,
                selection: selection
            )
        )
    }

    static func draw(player: String) -> Self {
        .init(
            kind: .draw,
            payload: .init(
                target: player
            )
        )
    }

    static func drawDeck(player: String) -> Self {
        .init(
            kind: .drawDeck,
            payload: .init(
                target: player
            )
        )
    }

    static func drawDiscard(player: String) -> Self {
        .init(
            kind: .drawDiscard,
            payload: .init(target: player)
        )
    }

    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            kind: .drawDiscovered,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func discover(player: String) -> Self {
        .init(
            kind: .discover,
            payload: .init(target: player)
        )
    }

    static func heal(_ amount: Int, player: String) -> Self {
        .init(
            kind: .heal,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            kind: .damage,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func discardHand(_ card: String, player: String) -> Self {
        .init(
            kind: .discardHand,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func discardInPlay(_ card: String, player: String) -> Self {
        .init(
            kind: .discardInPlay,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func stealHand(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .stealHand,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .stealInPlay,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func passInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .passInPlay,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func shoot(_ target: String, player: String) -> Self {
        .init(
            kind: .shoot,
            payload: .init(
                actor: player,
                target: target
            )
        )
    }

    static func counterShoot(player: String) -> Self {
        .init(
            kind: .counterShot,
            payload: .init(
                target: player
            )
        )
    }

    static func startTurn(player: String) -> Self {
        .init(
            kind: .startTurn,
            payload: .init(
                target: player
            )
        )
    }

    static func endTurn(player: String) -> Self {
        .init(
            kind: .endTurn,
            payload: .init(
                target: player
            )
        )
    }

    static func eliminate(player: String) -> Self {
        .init(
            kind: .eliminate,
            payload: .init(
                target: player
            )
        )
    }

    static func endGame(player: String) -> Self {
        .init(
            kind: .endGame,
            payload: .init(
                target: player
            )
        )
    }

    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            kind: .activate,
            payload: .init(target: player, cards: cards)
        )
    }

    static func play(_ card: String, player: String) -> Self {
        .init(
            kind: .play,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func equip(_ card: String, player: String) -> Self {
        .init(
            kind: .equip,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func handicap(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .handicap,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            kind: .setWeapon,
            payload: .init(target: player, amount: weapon)
        )
    }

    static func setPlayLimitPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            kind: .setPlayLimitPerTurn,
            payload: .init(
                target: player,
                amountPerCard: limit
            )
        )
    }

    static func increaseMagnifying(_ amount: Int, player: String) -> Self {
        .init(
            kind: .increaseMagnifying,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func increaseRemoteness(_ amount: Int, player: String) -> Self {
        .init(
            kind: .increaseRemoteness,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static var dummy: Self {
        .init(kind: .queue, payload: .init())
    }
}
