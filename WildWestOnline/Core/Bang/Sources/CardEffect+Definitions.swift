//
//  CardEffects.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length

/// Defining card effects
/// NAming = {action}_{arg1}_{arg2}_on{Event}_if{Condition}
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
                .if(.playersAtLeast3),
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
                .player(.all, conditions: [.damaged])
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
                .player(.any, conditions: [.havingCard]),
                .card(.any)
            ],
            when: .cardPlayed
        )
    }

    static var steal_any_atDistanceOf1: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .player(.any, conditions: [.atDistance1, .havingCard]),
                .card(.any)
            ],
            when: .cardPlayed
        )
    }

    static var shoot_any_reachable: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .if(.cardPlayedLessThanBangLimitPerTurn),
                .amount(.requiredMissesForBang),
                .player(.any, conditions: [.atDistanceReachable])
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
                .counterCard(.any, conditions: [.handCardNamedBang])
            ],
            when: .cardPlayed
        )
    }

    static var damage_any_reverseWithBang: CardEffect {
        .init(
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .player(.any),
                .reverseCard(.any, conditions: [.handCardNamedBang])
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
                .if(.drawHearts)
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
                .if(.notDrawsSpades),
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
                .if(.drawsSpades),
                .amount(.value(3))
            ],
            when: .turnStarted
        )
    }

    static var discard_onTurnStarted_ifDrawSpades: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .if(.drawsSpades),
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
                .player(.any),
                .card(.played)
            ],
            when: .cardPlayed
        )
    }

    static var endTurn_onTurnStarted_ifNotDrawHearts: CardEffect {
        .init(
            action: .endTurn,
            selectors: [
                .if(.notDrawHearts)
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
                .card(.any, conditions: [.handCard])
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
                .amount(.startTurnCards)
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
                .if(.isYourTurn)
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
                .activeCard(.any, conditions: [.handCardNamedMissed])
            ],
            when: .shot
        )
    }

    static var play_beer_onDamagedLethal: CardEffect {
        .init(
            action: .play,
            selectors: [
                .if(.playersAtLeast3),
                .activeCard(.any, conditions: [.handCardNamedBeer])
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

     static var vultureSam: Card {
         Card.makeBuilder(name: .vultureSam)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.steal(.all)
                     .target(.eliminated)
                     .on([.anotherEliminated])
             }
             .build()
     }

     static var sidKetchum: Card {
         Card.makeBuilder(name: .sidKetchum)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withRule {
                 CardEffect.group {
                     CardEffect.discard(.selectHand)
                         .repeat(2)
                     CardEffect.heal(1)
                 }
                 .on([.play])
             }
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

     static var kitCarlson: Card {
         Card.makeBuilder(name: .kitCarlson)
             .withPrototype(defaultPlayer)
             .withPriorityIndex(priorities)
             .withAttributes([.maxHealth: 4])
             .withoutAbility(.drawOnStartTurn)
             .withRule {
                 CardEffect.group {
                     CardEffect.drawDeck
                         .repeat(.add(1, attr: .startTurnCards))
                     CardEffect.putBack(among: .add(1, attr: .startTurnCards))
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
