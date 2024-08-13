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
    static var brown: Effect {
        .init(
            when: .played,
            action: .discardSilently,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var equip: Effect {
        .init(
            when: .played,
            action: .equip,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var shoot_reachable_bangLimitPerTurn: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .arg(.limitPerTurn, value: .value(1)),
                .arg(.shootRequiredMisses, value: .value(1)),
                .arg(.damageAmount, value: .value(1)),
                .if(.playedLessThan(.arg(.limitPerTurn))),
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
            ]
        )
    }
}

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

    // MARK: - Collectibles - Handicap

    static var handicap: Effect {
        .init(
            when: .played,
            action: .handicap,
            selectors: [
                .chooseTarget(),
                .card(.played)
            ]
        )
    }

    // MARK: - Abilities

    static var endTurn: Effect {
        .init(
            when: .played,
            action: .endTurn
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

    static var play_missed_onShot: Effect {
        .init(
            when: .shot,
            action: .play,
            selectors: [
                .chooseEventuallyCard(.action(.missed))
            ]
        )
    }

    static var play_beer_onDamagedLethal: Effect {
        .init(
            when: .damagedLethal,
            action: .play,
            selectors: [
                .if(.playersAtLeast(3)),
                .chooseEventuallyCard(.named("beer"))
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

    static var drawDeck_damage_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .repeat(.damage)
            ]
        )
    }

    static var heal_2_onOtherEliminated: Effect {
        .init(
            when: .otherEliminated,
            action: .heal,
            selectors: [
                .arg(.healAmount, value: .value(2))
            ]
        )
    }

    static var drawDeck_2_onOtherEliminated: Effect {
        .init(
            when: .otherEliminated,
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ]
        )
    }

    static var drawDeck_onPlayedCardOutOfTurn: Effect {
        .init(
            when: .playedCardOutOfTurn,
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2)))
            ]
        )
    }

    static var drawDeck_2_costBlueHandCard: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2))),
                .chooseCostHandCard(.isBlue),
                .repeat(.value(2))
            ]
        )
    }

    static var drawDeck_2_cost1LifePoint: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .chooseEventuallyCostLifePoint,
                .repeat(.value(2))
            ]
        )
    }

    static var shoot_reachable_cost2HandCards: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.value(1))),
                .chooseCostHandCard(count: 2),
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
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

    static var heal: Effect {
        .init(
            when: .played,
            action: .heal
        )
    }

    static var drawDeck_all_2_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .target(.all),
                .chooseCostHandCard(),
                .repeat(.value(2))
            ]
        )
    }

    static var shoot_reachable: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
            ]
        )
    }

    static var shoot_atDistanceOf2: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.atDistance(.value(2))])
            ]
        )
    }

    static var shoot_neighbour: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.neighbourToTarget])
            ]
        )
    }

    static var play_onOtherDamaged: Effect {
        .init(
            when: .otherDamaged,
            action: .play,
            selectors: [
                .chooseEventuallyCard(.named("saved"))
            ]
        )
    }

    static var heal_lastDamaged: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .target(.damaged)
            ]
        )
    }

    static var damage_others_counterWith2HandCards: Effect {
        .init(
            when: .played,
            action: .damage,
            selectors: [
                .target(.others),
                .chooseEventuallyCounterHandCard(count: 2)
            ]
        )
    }

    static var discard_others: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .target(.others),
                .chooseCard()
            ]
        )
    }

    static var drawDiscard_2_ifDiscardedCardsNotAce: Effect {
        .init(
            when: .played,
            action: .drawDiscard,
            selectors: [
                .if(.discardedCardsNotAce),
                .repeat(.value(2))
            ]
        )
    }

    static var setAttribute_playBangWithAny: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .attr(.playBangWithAny, value: 0)
            ]
        )
    }

    static var discard_anyHand_onDamagingWithBang: Effect {
        .init(
            when: .damagingWith("bang"),
            action: .discard,
            selectors: [
                .target(.damaged),
                .chooseCard(.fromHand)
            ]
        )
    }

    static var play_onBangPlayed: Effect {
        .init(
            when: .cardPlayedWithName("bang"),
            action: .play,
            selectors: [
                .chooseEventuallyCard(.named("aim"))
            ]
        )
    }

    static var setAttribute_bangDamage_2: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .overrideArg(.damageAmount, value: 2, card: "bang")
            ]
        )
    }

    static var drawDeck_offender_onDamagedWithBang: Effect {
        .init(
            when: .damagedWith("bang"),
            action: .drawDeck,
            selectors: [
                .target(.offender)
            ]
        )
    }

    static var damage_onTurnStarted_ifDrawSpades: Effect {
        .init(
            when: .turnStarted,
            action: .damage,
            selectors: [
                .if(.draw("♠️"))
            ]
        )
    }

    static var drawDeck_2_onTurnStarted_ifHasNoBlueCardsInPlay: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .if(.hasNoBlueCardsInPlay)
            ]
        )
    }

    static var draw_onMissedBang: Effect {
        .init(
            when: .missed("bang"),
            action: .draw
        )
    }

    static var damage_target_onMissedBang_ifDrawSpades: Effect {
        .init(
            when: .missed("bang"),
            action: .damage,
            selectors: [
                .if(.draw("♠️")),
                .target(.targeted)
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
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
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
