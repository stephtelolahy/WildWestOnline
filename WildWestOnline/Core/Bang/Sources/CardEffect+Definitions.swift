//
//  CardEffects.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length

/// Defining card effects
/// Naming = {action}_{arg1}_{arg2}_on{Event}_if{Condition}
///
/// ⚠️ Before dispatching resolved action, verify initial event is still confirmed as state
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

    static var setWeapon_2: CardEffect {
        .init(
            action: .setWeapon,
            selectors: [
                .amount(.value(2))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setWeapon_3: CardEffect {
        .init(
            action: .setWeapon,
            selectors: [
                .amount(.value(3))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setWeapon_4: CardEffect {
        .init(
            action: .setWeapon,
            selectors: [
                .amount(.value(4))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setWeapon_5: CardEffect {
        .init(
            action: .setWeapon,
            selectors: [
                .amount(.value(5))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setWeapon_1: CardEffect {
        .init(
            action: .setWeapon,
            selectors: [
                .amount(.value(1))
            ],
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var setUnlimitedBang: CardEffect {
        .init(
            action: .setUnlimitedBang,
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var increaseMagnifying: CardEffect {
        .init(
            action: .increaseMagnifying,
            when: .cardPlayed,
            until: .cardDiscarded
        )
    }

    static var increaseRemoteness: CardEffect {
        .init(
            action: .increaseRemoteness,
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

    static var drawDeck_onTurnStarted: CardEffect {
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
}

/*
 private extension Cards {
     static var slabTheKiller: Card {
         Card.makeBuilder(name: .slabTheKiller)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4, .requiredMissesForBang: 2])
             .build()
     }

     static var luckyDuke: Card {
         Card.makeBuilder(name: .luckyDuke)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4, .flippedCards: 2])
             .build()
     }

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

     static var blackJack: Card {
         Card.makeBuilder(name: .blackJack)
             .withPrototype(defaultPlayer)
             .withPriorityIndex(priorities)
             .withAttributes([.maxHealth: 4])
             .withoutAbility(.drawOnStartTurn)
             .withRule {
                 CardEffect.group {
                     CardEffect.drawDeck
                         .repeat(.attr(.startTurnCards))
                     CardEffect.revealLastHand
                     CardEffect.luck(.drawnHand, regex: .regexDrawAnotherCard, onSuccess: .drawDeck)
                 }
                 .on([.startTurn])
             }
             .build()
     }

     static var jesseJones: Card {
         Card.makeBuilder(name: .jesseJones)
             .withPrototype(defaultPlayer)
             .withPriorityIndex(priorities)
             .withAttributes([.maxHealth: 4])
             .withoutAbility(.drawOnStartTurn)
             .withRule {
                 CardEffect.group {
                     CardEffect.drawDiscard
                         .force(otherwise: .drawDeck)
                     CardEffect.drawDeck
                         .repeat(.add(-1, attr: .startTurnCards))
                 }
                 .on([.startTurn])
             }
             .build()
     }

     static var pedroRamirez: Card {
         Card.makeBuilder(name: .pedroRamirez)
             .withPrototype(defaultPlayer)
             .withPriorityIndex(priorities)
             .withAttributes([.maxHealth: 4])
             .withoutAbility(.drawOnStartTurn)
             .withRule {
                 CardEffect.group {
                     CardEffect.steal(.selectHand)
                         .target(.any)
                         .force(otherwise: .drawDeck)
                     CardEffect.drawDeck
                         .repeat(.add(-1, attr: .startTurnCards))
                 }
                 .on([.startTurn])
             }
             .build()
     }

     static var custom: Card {
         Card.makeBuilder(name: .custom)
             .withPrototype(defaultPlayer)
             .withAttributes([
                     .maxHealth: 4,
                     .startTurnCards: 3,
                     .requiredMissesForBang: 2,
                     .bangsPerTurn: 0,
                     .magnifying: 1,
                     .remoteness: 1,
                     .flippedCards: 2
             ])
             .withAbilityToPlayCardAs([
                 CardAlias(playedRegex: .missed, as: .bang, playReqs: [.isYourTurn]),
                 CardAlias(playedRegex: .bang, as: .missed, playReqs: [.isNot(.isYourTurn)])
             ])
             .withAbilities([
                 .jourdonnais,
                 .bartCassidy,
                 .elGringo,
                 .suzyLafayette,
                 .vultureSam,
                 .sidKetchum,
                 .blackJack,
                 .kitCarlson,
                 .jesseJones,
                 .pedroRamirez
             ])
             .build()
     }
 }
 */
