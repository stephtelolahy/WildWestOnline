// swiftlint:disable:this file_name
//  Tags.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers

/// Defining Tags
/// ℹ️ Naming = {action}_{argValue}_on{Event}_if{Condition}
///
///

extension Effect {
    // MARK: - Collectible - Equipment

    static var discard_excessHand_onTurnEnded: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .repeat(.excessHand),
                .chooseCard()
            ]
        )
    }

    static var startTurn_next_onTurnEnded: Effect {
        .init(
            when: .turnEnded,
            action: .startTurn,
            selectors: [
                .target(.next)
            ]
        )
    }

    static var eliminate_onDamageLethal: Effect {
        .init(
            when: .damagedLethal,
            action: .eliminate
        )
    }

    static var discard_all_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .discard,
            selectors: [
                .card(.all)
            ]
        )
    }

    static var endTurn_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .endTurn,
            selectors: [
                .if(.actorTurn)
            ]
        )
    }

    static var discard_previousWeapon_onWeaponPlayed: Effect {
        .init(
            when: .cardPlayedWithAttr(.weapon),
            action: .discard,
            selectors: [
                .card(.inPlayWithAttr(.weapon))
            ]
        )
    }

    // MARK: - Figures

    static var reveal_3_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .reveal,
            selectors: [
                .arg(.revealAmount, value: .value(3))
            ]
        )
    }

    static var chooseCard_2_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .chooseCard,
            selectors: [
                .repeat(.value(3))
            ]
        )
    }

    static var showLastDraw_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .showLastDraw
        )
    }

    static var drawDeck_onTurnStarted_IfDrawsRed: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .if(.draw("(♥️)|(♦️)"))
            ]
        )
    }

    static var drawDiscard_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDiscard
        )
    }

    static var steal_any_fromHand_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .steal,
            selectors: [
                .chooseTarget([.havingHandCard]),
                .chooseCard()
            ]
        )
    }

    // MARK: - Dodge city

    static var steal_any_inPlay_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .steal,
            selectors: [
                .chooseTarget([.havingInPlayCard]),
                .chooseCard(.inPlay)
            ]
        )
    }

    // MARK: - The Valley of Shadows

    static var drawDeck_2_onTurnStarted_ifHasNoBlueCardsInPlay: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .if(.hasNoBlueCardsInPlay)
            ]
        )
    }
}
