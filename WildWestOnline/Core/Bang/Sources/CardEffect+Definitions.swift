//
//  CardEffects.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length

/// Defining card effects
/// ℹ️ Naming = {action}_{arg1}_{arg2}_on{Event}_if{Condition}
/// ⚠️ Before dispatching resolved action, verify initial event is still confirmed as state
/// ⚠️ Each effect triggered by a single event are linked, the failure of the first induce the sskipping of next
extension CardEffect {
    // MARK: - Collectible - Action

    static var discardSilently: CardEffect {
        .init(
            action: .discardSilently,
            selectors: [
                .card(.played)
            ],
            when: .cardPlayed
        )
    }

    static var heal_1_ifPlayersAtLeast3: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .if(.playersAtLeast(3)),
                .amount(.value(1))
            ],
            when: .cardPlayed
        )
    }

    static var heal_1_all: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .amount(.value(1)),
                .player(.all)
            ],
            when: .cardPlayed
        )
    }

    static var drawDeck_2: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ],
            when: .cardPlayed
        )
    }

    static var drawDeck_3: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.value(3))
            ],
            when: .cardPlayed
        )
    }

    static var discard_any: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .player(.any([.havingCard])),
                .card(.any())
            ],
            when: .cardPlayed
        )
    }

    static var steal_any_atDistanceOf1: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .player(.any([.atDistance(.value(1)), .havingCard])),
                .card(.any())
            ],
            when: .cardPlayed
        )
    }

    static var shoot_any_reachable: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .if(.cardPlayedLessThan(.attr(.bangLimitPerTurn))),
                .amount(.attr(.requiredMissesForBang)),
                .player(.any([.atDistance(.attr(.weapon))]))
            ],
            when: .cardPlayed
        )
    }

    static var missed: CardEffect {
        .init(
            action: .missed,
            when: .cardPlayed
        )
    }

    static var shoot_others: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .amount(.value(1)),
                .player(.others)
            ],
            when: .cardPlayed
        )
    }

    static var damage_others_counterWithBang: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .player(.others),
                .counterWith(.any([.fromHand, .named("bang")]))
            ],
            when: .cardPlayed
        )
    }

    static var damage_any_reverseWithBang: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .player(.any()),
                .reverseWith(.any([.fromHand, .named("bang")]))
            ],
            when: .cardPlayed
        )
    }

    static var reveal_activePlayers: CardEffect {
        .init(
            action: .reveal,
            selectors: [
                .amount(.activePlayers)
            ],
            when: .cardPlayed
        )
    }

    static var chooseCard_all: CardEffect {
        .init(
            action: .chooseCard,
            selectors: [
                .player(.all),
                .card(.anyChoosable)
            ],
            when: .cardPlayed
        )
    }

    // MARK: - Collectible - Equipment

    static var equip: CardEffect {
        .init(
            action: .equip,
            selectors: [
                .card(.played)
            ],
            when: .cardPlayed
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
                .if(.notDraw("[2-9]♠️")),
                .player(.next),
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

    static var setAttribute_weapon_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(2))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setAttribute_weapon_3: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(3))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setAttribute_weapon_4: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(4))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setAttribute_weapon_5: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(5))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setAttribute_weapon_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(1))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setAttribute_bangLimitPerTurn_0: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangLimitPerTurn),
                .amount(.value(0))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var incrementAttribute_magnifying: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.magnifying)
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var incrementAttribute_remoteness: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.remoteness)
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    // MARK: - Collectibles - Handicap

    static var handicap: CardEffect {
        .init(
            action: .handicap,
            selectors: [
                .player(.any()),
                .card(.played)
            ],
            when: .cardPlayed
        )
    }

    static var endTurn_onTurnStarted_ifNotDrawHearts: CardEffect {
        .init(
            action: .endTurn,
            selectors: [
                .if(.notDraw("♥️"))
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
            when: .cardPlayed
        )
    }

    static var discard_excessHand: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .repeat(.excessHand),
                .card(.any([.fromHand]))
            ],
            when: .cardPlayed
        )
    }

    static var startTurn_next_onTurnEnded: CardEffect {
        .init(
            action: .startTurn,
            selectors: [
                .player(.next)
            ],
            when: .turnEnded
        )
    }

    static var drawDeck_startTurnCards_onTurnStarted: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .amount(.attr(.startTurnCards))
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
                .card(.previousWeapon)
            ],
            when: .weaponPlayed
        )
    }

    static var play_missed_onShot: CardEffect {
        .init(
            action: .play,
            selectors: [
                .cardOrIgnore(.any([.fromHand, .action(.missed)]))
            ],
            when: .shot
        )
    }

    static var play_beer_onDamagedLethal: CardEffect {
        .init(
            action: .play,
            selectors: [
                .if(.playersAtLeast(3)),
                .cardOrIgnore(.any([.fromHand, .named("beer")]))
            ],
            when: .damagedLethal
        )
    }

    // MARK: - Figures

    static var drawDeck_onDamaged: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.damage)
            ],
            when: .damaged
        )
    }

    static var steal_offender_onDamaged: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .player(.offender),
                .repeat(.damage)
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

    static var discard_2_hand: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .repeat(.value(2)),
                .card(.any([.fromHand]))
            ],
            when: .cardPlayed
        )
    }

    static var heal_1: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .amount(.value(1))
            ],
            when: .cardPlayed
        )
    }

    static var steal_all_onOtherEliminated: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .player(.eliminated),
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
            when: .cardPlayed
        )
    }

    static var chooseCard_startTurnCards: CardEffect {
        .init(
            action: .chooseCard,
            selectors: [
                .repeat(.attr(.startTurnCards))
            ],
            when: .cardPlayed
        )
    }

    static var revealLastDraw_onTurnStarted: CardEffect {
        .init(
            action: .revealLastDraw,
            when: .turnStarted
        )
    }

    static var drawDeck_1_onTurnStarted_IfDrawsRed: CardEffect {
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

    static var drawDeck_startTurnCardsMinus1_onTurnStarted: CardEffect {
        .init(
            action: .drawDeck,
            selectors: [
                .repeat(.add(-1, attr: .startTurnCards))
            ],
            when: .turnStarted
        )
    }

    static var steal_any_onTurnStarted: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .player(.any()),
                .card(.any())
            ],
            when: .turnStarted
        )
    }

    static var setAttribute_requiredMissesForBang_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.requiredMissesForBang),
                .amount(.value(2))
            ],
            when: .cardPlayed
        )
    }

    static var setAttribute_maxHealth_4: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.maxHealth),
                .amount(.value(4))
            ],
            when: .cardPlayed
        )
    }

    static var setAttribute_flippedCards_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.flippedCards),
                .amount(.value(2))
            ],
            when: .cardPlayed
        )
    }
}

/*
 private extension Cards {

     static var calamityJanet: Card {
         Card.makeBuilder(name: .calamityJanet)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withAbilityToPlayCardAs([
                 CardAlias(playedRegex: .missed, as: .bang, playReqs: [.isYourTurn]),
                 CardAlias(playedRegex: .bang, as: .missed, playReqs: [.isNot(.isYourTurn)])
             ])
             .build()
     }
 */
