// swiftlint:disable:this file_name
//  Tags.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length type_contents_order

/// Defining Tags
/// ℹ️ Naming = {action}_{argValue}_on{Event}_if{Condition}
/// ℹ️ Before dispatching resolved action, verify initial event is still confirmed as state
///
///

extension Effect {

    // MARK: - Collectible - Equipment

    static var draw_onShot: Effect {
        .init(
            when: .shot,
            action: .draw
        )
    }

    static var draw_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .draw
        )
    }

    static func setAttribute_weapon(_ value: Int) -> Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.weapon, value: value)
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

    static var drawDeck_2_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .arg(.repeatAmount, value: .value(2)),
                .repeat(.arg(.repeatAmount))
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

    static func setAttribute_maxHealth(_ value: Int) -> Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.maxHealth, value: value)
            ]
        )
    }

    // MARK: - Dodge city

    static var setAttribute_handLimit_10: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.handLimit, value: 10)
            ]
        )
    }

    static var setAttribute_startTurnCards_1: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .overrideArg(.repeatAmount, value: 1, card: "startTurn")
            ]
        )
    }

    static var setAttribute_startTurnCards_0: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .overrideArg(.repeatAmount, value: 0, card: "startTurn")
            ]
        )
    }

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

    static var setAttribute_silentCardsDiamonds: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.silentCardsDiamonds, value: 0)
            ]
        )
    }

    static var setAttribute_silentCardsInPlayDuringTurn: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.silentCardsInPlayDuringTurn, value: 0)
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

    static var heal_onOtherPlayedBeer_cost1HandCard: Effect {
        .init(
            when: .otherPlayedCardWithName("beer"),
            action: .heal,
            selectors: [
                .chooseCostHandCard()
            ]
        )
    }

    static var shoot_offender_onCardStolen: Effect {
        .init(
            when: .cardStolen,
            action: .shoot,
            selectors: [
                .target(.offender)
            ]
        )
    }

    static var shoot_offender_onCardDiscarded: Effect {
        .init(
            when: .cardDiscarded,
            action: .shoot,
            selectors: [
                .target(.offender)
            ]
        )
    }

    static var shoot_reachable_oncePerTurn_costClubsHandCard: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.value(1))),
                .chooseCostHandCard(.suits("♣️")),
                .chooseTarget([.atDistanceReachable])
            ]
        )
    }

    static var shoot_others_oncePerTurn_costBangHandCard: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.value(1))),
                .chooseCostHandCard(.named("bang")),
                .target(.others)
            ]
        )
    }
}
