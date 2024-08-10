// swiftlint:disable:this file_name
//  Tags.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length

/// Defining card effects
/// ℹ️ Naming = {action}_{argValue}_on{Event}_if{Condition}
/// ⚠️ Before dispatching resolved action, verify initial event is still confirmed as state
extension CardEffect {
    // MARK: - Collectible - Action

    static var brown: CardEffect {
        .init(
            action: .discardSilently,
            selectors: [
                .card(.played)
            ],
            when: .played
        )
    }

    static var heal_ifPlayersAtLeast3: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .if(.playersAtLeast(3)),
                .amount(.value(1))
            ],
            when: .played
        )
    }

    static var heal_all: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .target(.all),
                .amount(.value(1))
            ],
            when: .played
        )
    }

    static var drawDeck_2: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ],
            when: .played
        )
    }

    static var drawDeck_3: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.value(3))
            ],
            when: .played
        )
    }

    static var discard_any: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .target(.any([.havingCard()])),
                .card(.any())
            ],
            when: .played
        )
    }

    static var steal_atDistanceOf1: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .target(.any([.atDistance(.value(1)), .havingCard()])),
                .card(.any())
            ],
            when: .played
        )
    }

    static var shoot_reachable_bangLimitPerTurn: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.attr(.bangLimitPerTurn))),
                .target(.any([.atDistance(.attr(.weapon))])),
                .requiredMisses(.attr(.bangRequiredMisses))
            ],
            when: .played
        )
    }

    static var missed: CardEffect {
        .init(
            action: .missed,
            when: .played
        )
    }

    static var shoot_others: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .target(.others),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var damage_others_counterWithBang: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .target(.others),
                .counterCost(.any([.fromHand, .named("bang")]))
            ],
            when: .played
        )
    }

    static var damage_any_reverseWithBang: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .target(.any()),
                .reverseCost(.any([.fromHand, .named("bang")]))
            ],
            when: .played
        )
    }

    static var reveal_activePlayers: CardEffect {
        .init(
            action: .reveal,
            selectors: [
                .amount(.activePlayers)
            ],
            when: .played
        )
    }

    static var chooseCard_all: CardEffect {
        .init(
            action: .chooseCard,
            selectors: [
                .target(.all),
                .card(.anyChoosable)
            ],
            when: .played
        )
    }

    // MARK: - Collectible - Equipment

    static var equip: CardEffect {
        .init(
            action: .equip,
            selectors: [
                .card(.played)
            ],
            when: .played
        )
    }

    static var draw_onShot: CardEffect {
        .init(
            action: .draw,
            when: .shot
        )
    }

    static var missed_onShot_ifDrawHearts: CardEffect {
        .init(
            action: .missed,
            selectors: [
                .if(.draw("♥️"))
            ],
            when: .shot
        )
    }

    static var draw_onTurnStarted: CardEffect {
        .init(
            action: .draw,
            when: .turnStarted
        )
    }

    static var pass_next_onTurnStarted_ifNotDrawSpades: CardEffect {
        .init(
            action: .pass,
            selectors: [
                .if(.not(.draw("[2-9]♠️"))),
                .target(.next),
                .card(.played)
            ],
            when: .turnStarted
        )
    }

    static var damage_3_onTurnStarted_ifDrawSpades: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .if(.draw("[2-9]♠️")),
                .amount(.value(3))
            ],
            when: .turnStarted
        )
    }

    static var discard_onTurnStarted_ifDrawSpades: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .if(.draw("[2-9]♠️")),
                .card(.played)
            ],
            when: .turnStarted
        )
    }

    static var setAttribute_weapon_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon, value: 1)
            ],
            when: .played
        )
    }

    static var setAttribute_weapon_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon, value: 2)
            ],
            when: .played
        )
    }

    static var setAttribute_weapon_3: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon, value: 3)
            ],
            when: .played
        )
    }

    static var setAttribute_weapon_4: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon, value: 4)
            ],
            when: .played
        )
    }

    static var setAttribute_weapon_5: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon, value: 5)
            ],
            when: .played
        )
    }

    static var setAttribute_bangLimitPerTurn_0: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangLimitPerTurn, value: 0)
            ],
            when: .played
        )
    }

    static var setAttribute_bangLimitPerTurn_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangLimitPerTurn, value: 1)
            ],
            when: .played
        )
    }

    static var incrementAttribute_magnifying: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.magnifying, value: 1)
            ],
            when: .played
        )
    }

    static var incrementAttribute_remoteness: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.remoteness, value: 1)
            ],
            when: .played
        )
    }

    // MARK: - Collectibles - Handicap

    static var handicap: CardEffect {
        .init(
            action: .handicap,
            selectors: [
                .target(.any()),
                .card(.played)
            ],
            when: .played
        )
    }

    static var endTurn_onTurnStarted_ifNotDrawHearts: CardEffect {
        .init(
            action: .endTurn,
            selectors: [
                .if(.not(.draw("♥️")))
            ],
            when: .turnStarted
        )
    }

    static var discard_onTurnStarted: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .card(.played)
            ],
            when: .turnStarted
        )
    }

    // MARK: - Abilities

    static var endTurn: CardEffect {
        .init(
            action: .endTurn,
            when: .played
        )
    }

    static var discard_excessHand: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .repeat(.excessHand),
                .card(.any([.fromHand]))
            ],
            when: .played
        )
    }

    static var startTurn_next_onTurnEnded: CardEffect {
        .init(
            action: .startTurn,
            selectors: [
                .target(.next)
            ],
            when: .turnEnded
        )
    }

    static var drawDeck_remainingStartTurnCards_onTurnStarted: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .amount(.remainingStartTurnCards)
            ],
            when: .turnStarted
        )
    }

    static var eliminate_onDamageLethal: CardEffect {
        .init(
            action: .eliminate,
            when: .damagedLethal
        )
    }

    static var discard_all_onEliminated: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .card(.all)
            ],
            when: .eliminated
        )
    }

    static var endTurn_onEliminated: CardEffect {
        .init(
            action: .endTurn,
            selectors: [
                .if(.actorTurn)
            ],
            when: .eliminated
        )
    }

    static var discard_previousWeapon_onWeaponPlayed: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .card(.inPlay(.attr(.weapon)))
            ],
            when: .cardPlayed(.attr(.weapon))
        )
    }

    static var play_missed_onShot: CardEffect {
        .init(
            action: .play,
            selectors: [
                .cardOrSkip(.any([.fromHand, .action(.missed)]))
            ],
            when: .shot
        )
    }

    static var play_beer_onDamagedLethal: CardEffect {
        .init(
            action: .play,
            selectors: [
                .if(.playersAtLeast(3)),
                .cardOrSkip(.any([.fromHand, .named("beer")]))
            ],
            when: .damagedLethal
        )
    }

    // MARK: - Figures

    static var drawDeck_onDamaged: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.lastDamage)
            ],
            when: .damaged
        )
    }

    static var steal_offender_onDamaged: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .target(.offender),
                .repeat(.lastDamage)
            ],
            when: .damaged
        )
    }

    static var drawDeck_onHandEmpty: CardEffect {
        .init(
            action: .drawDeck,
            when: .handEmpty
        )
    }

    static var heal_cost2HandCards: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand])),
                .cost(.any([.fromHand])),
                .amount(.value(1))
            ],
            when: .played
        )
    }

    static var steal_all_onOtherEliminated: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .target(.eliminated),
                .card(.all)
            ],
            when: .otherEliminated
        )
    }

    static var reveal_startTurnCardsPlus1: CardEffect {
        .init(
            action: .reveal,
            selectors: [
                .amount(.add(1, attr: .startTurnCards))
            ],
            when: .played
        )
    }

    static var chooseCard_startTurnCards: CardEffect {
        .init(
            action: .chooseCard,
            selectors: [
                .repeat(.attr(.startTurnCards))
            ],
            when: .played
        )
    }

    static var showLastDraw_onTurnStarted: CardEffect {
        .init(
            action: .showLastDraw,
            when: .turnStarted
        )
    }

    static var drawDeck_onTurnStarted_IfDrawsRed: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .if(.draw("(♥️)|(♦️)"))
            ],
            when: .turnStarted
        )
    }

    static var drawDiscard_onTurnStarted: CardEffect {
        .init(
              action: .drawDiscard,
              when: .turnStarted
        )
    }

    static var steal_any_fromHand_onTurnStarted: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .target(.any([.havingCard(.fromHand)])),
                .card(.any([.fromHand]))
            ],
            when: .turnStarted
        )
    }

    static var setAttribute_startTurnCards_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.startTurnCards, value: 2)
            ],
            when: .played
        )
    }

    static var setAttribute_bangRequiredMisses_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangRequiredMisses, value: 1)
            ],
            when: .played
        )
    }

    static var setAttribute_bangRequiredMisses_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangRequiredMisses, value: 2)
            ],
            when: .played
        )
    }

    static var setAttribute_maxHealth_4: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.maxHealth, value: 4)
            ],
            when: .played
        )
    }

    static var setAttribute_maxHealth_3: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.maxHealth, value: 3)
            ],
            when: .played
        )
    }

    static var setAttribute_drawCards_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.drawCards, value: 2)
            ],
            when: .played
        )
    }

    static var setAttribute_drawCards_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.drawCards, value: 1)
            ],
            when: .played
        )
    }

    static var setAttribute_bangWithMissed: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangWithMissed, value: 0)
            ],
            when: .played
        )
    }

    static var setAttribute_missedWithBang: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.missedWithBang, value: 0)
            ],
            when: .played
        )
    }

    // MARK: - Dodge city

    static var shoot_atDistanceOf1: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .target(.any([.atDistance(.value(1))])),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var drawDeck: CardEffect {
        .init(
            action: .drawDeck,
            when: .played
        )
    }

    static var shoot_any_cost1HandCard: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .cost(.any([.fromHand])),
                .target(.any()),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var heal_2_cost1HandCard: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand])),
                .amount(.value(2))
            ],
            when: .played
        )
    }

    static var heal_any_cost1HandCard: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand])),
                .target(.any()),
                .amount(.value(1))
            ],
            when: .played
        )
    }

    static var steal_any_cost1HandCard: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .cost(.any([.fromHand])),
                .target(.any()),
                .card(.any())
            ],
            when: .played
        )
    }

    static var discard_all_cost1HandCard: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .cost(.any([.fromHand])),
                .target(.all),
                .card(.any())
            ],
            when: .played
        )
    }

    static var setAttribute_missedWithAny: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.missedWithAny, value: 0)
            ],
            when: .played
        )
    }

    static var setAttribute_handLimit_10: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.handLimit, value: 10)
            ],
            when: .played
        )
    }

    static var heal_onBeerPlayed: CardEffect {
        .init(
            action: .heal,
            when: .cardPlayed(.named("beer"))
        )
    }

    static var setAttribute_startTurnCards_3: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.startTurnCards, value: 3)
            ],
            when: .played
        )
    }

    static var setAttribute_startTurnCards_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.startTurnCards, value: 1)
            ],
            when: .played
        )
    }

    static var drawDeck_damage_onTurnStarted: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.damage)
            ],
            when: .turnStarted
        )
    }

    static var heal_2_onOtherEliminated: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .amount(.value(2))
            ],
            when: .otherEliminated
        )
    }

    static var drawDeck_2_onOtherEliminated: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ],
            when: .otherEliminated
        )
    }

    static var drawDeck_onPlayedCardOutOfTurn: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2)))
            ],
            when: .playedCardOutOfTurn
        )
    }

    static var drawDeck_2_costBlueHandCard: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2))),
                .cost(.any([.fromHand, .isBlue])),
                .repeat(.value(2))
            ],
            when: .played
        )
    }

    static var drawDeck_2_cost1LifePoint: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .looseLifePointOrSkip,
                .repeat(.value(2))
            ],
            when: .played
        )
    }

    static var shoot_reachable_cost2HandCards: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.value(1))),
                .cost(.any([.fromHand])),
                .cost(.any([.fromHand])),
                .target(.any([.atDistance(.attr(.weapon))])),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var steal_any_inPlay_onTurnStarted: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .target(.any([.havingCard(.inPlay)])),
                .card(.any([.inPlay]))
            ],
            when: .turnStarted
        )
    }

    static var setAttribute_silentCardsDiamonds: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.silentCardsDiamonds, value: 0)
            ],
            when: .played
        )
    }

    static var setAttribute_silentCardsInPlayDuringTurn: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.silentCardsInPlayDuringTurn, value: 0)
            ],
            when: .played
        )
    }

    // MARK: - The Valley of Shadows

    static var heal: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .amount(.value(1))
            ],
            when: .played
        )
    }

    static var drawDeck_all_2_cost1HandCard: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .target(.all),
                .cost(.any([.fromHand])),
                .amount(.value(2))
            ],
            when: .played
        )
    }

    static var shoot_reachable: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .target(.any([.atDistance(.attr(.weapon))])),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var shoot_atDistanceOf2: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .target(.any([.atDistance(.value(2))])),
                .requiredMisses(.value(1))
            ],
            when: .played
        )
    }

    static var shoot_reachableAndNeighbour: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.attr(.bangLimitPerTurn))),
                .target(.anyAndNeighbour([.atDistance(.attr(.weapon))])),
                .requiredMisses(.attr(.bangRequiredMisses))
            ],
            when: .played
        )
    }
}
