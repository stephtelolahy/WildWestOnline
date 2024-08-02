// The Swift Programming Language
// https://docs.swift.org/swift-book
// swiftlint:disable no_magic_numbers file_length

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
///
typealias Card = [CardEffect]

public enum Cards {
    static let all: [String: Card] = [
        "beer": [
            discardOnPlayed,
            heal1
        ],
        "saloon": [
            discardOnPlayed,
            heal1All
        ],
        "stagecoach": [
            discardOnPlayed,
            draw2Cards
        ],
        "wellsFargo": [
            discardOnPlayed,
            draw3Cards
        ],
        "catBalou": [
            discardOnPlayed,
            discardAnyOther
        ],
        "panic": [
            discardOnPlayed,
            stealAnyOtherAtDistanceOf1
        ],
        "bang": [
            discardOnPlayed,
            shootAnyReachable
        ],
        "missed": [
            discardOnPlayed,
            counterShoot
        ],
        "gatling": [
            discardOnPlayed,
            shootOthers
        ],
        "indians": [
            discardOnPlayed,
            damageOthersCounterWithBang
        ],
        "duel": [
            discardOnPlayed,
            damageAnyReverseWithBang
        ],
        "generalStore": [
            discardOnPlayed,
            revealCardsAsPlayersCount,
            chooseCardAll
        ],
        "barrel": [
            equipment,
            drawOnShot,
            counterShootOnSuccessfulDraw
        ],
        "dynamite": [
            equipment,
            drawOnTurnStarted,
            passInPlayOnSuccessfulDraw,
            damage3OnFailedDraw,
            discardOnFailedDraw
        ],
        "schofield": [
            equipment,
            weapon2
        ],
        "remington": [
            equipment,
            weapon3
        ],
        "revCarabine": [
            equipment,
            weapon4
        ],
        "winchester": [
            equipment,
            weapon5
        ],
        "volcanic": [
            equipment,
            weapon1,
            unlimitedBang
        ]
    ]
}

private extension Cards {
    // MARK: - Collectible - Action

    static var discardOnPlayed: CardEffect {
        .init(
            when: .cardPlayed,
            action: .discardPlayed,
            selectors: [
                .player(.actor),
                .card(.played)
            ]
        )
    }

    static var heal1: CardEffect {
        .init(
            when: .cardPlayed,
            action: .heal,
            selectors: [
                .if([.playersAtLeast3]),
                .amount(.value(1)),
                .player(.actor)
            ]
        )
    }

    static var heal1All: CardEffect {
        .init(
            when: .cardPlayed,
            action: .heal,
            selectors: [
                .amount(.value(1)),
                .player(.all, conditions: [.damaged])
            ]
        )
    }

    static var draw2Cards: CardEffect {
        .init(
            when: .cardPlayed,
            action: .drawDeck,
            selectors: [
                .player(.actor),
                .repeat(2)
            ]
        )
    }

    static var draw3Cards: CardEffect {
        .init(
            when: .cardPlayed,
            action: .drawDeck,
            selectors: [
                .player(.actor),
                .repeat(3)
            ]
        )
    }

    static var discardAnyOther: CardEffect {
        .init(
            when: .cardPlayed,
            action: .discard,
            selectors: [
                .player(.any, conditions: [.havingCard]),
                .card(.any)
            ]
        )
    }

    static var stealAnyOtherAtDistanceOf1: CardEffect {
        .init(
            when: .cardPlayed,
            action: .steal,
            selectors: [
                .player(.any, conditions: [.atDistance1, .havingCard]),
                .card(.any)
            ]
        )
    }

    static var shootAnyReachable: CardEffect {
        .init(
            when: .cardPlayed,
            action: .shoot,
            selectors: [
                .if([.cardPlayedLessThanBangLimitPerTurn]),
                .requiredMisses(.requiredMissesForBang),
                .player(.any, conditions: [.atDistanceReachable])
            ]
        )
    }

    static var counterShoot: CardEffect {
        .init(
            when: .cardPlayed,
            action: .counterShoot,
            selectors: [
                .player(.actor)
            ]
        )
    }

    static var shootOthers: CardEffect {
        .init(
            when: .cardPlayed,
            action: .shoot,
            selectors: [
                .requiredMisses(.value(1)),
                .player(.others)
            ]
        )
    }

    static var damageOthersCounterWithBang: CardEffect {
        .init(
            when: .cardPlayed,
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .player(.others),
                .counterCard(.any, conditions: [.handCardNamedBang])
            ]
        )
    }

    static var damageAnyReverseWithBang: CardEffect {
        .init(
            when: .cardPlayed,
            action: .damage,
            selectors: [
                .amount(.value(1)),
                .player(.any),
                .reverseCard(.any, conditions: [.handCardNamedBang])
            ]
        )
    }

    static var revealCardsAsPlayersCount: CardEffect {
        .init(
            when: .cardPlayed,
            action: .reveal,
            selectors: [
                .amount(.numberOfPlayers)
            ]
        )
    }

    static var chooseCardAll: CardEffect {
        .init(
            when: .cardPlayed,
            action: .chooseCard,
            selectors: [
                .player(.all),
                .card(.anyChoosable)
            ]
        )
    }

    // MARK: - Collectible - Equipment

    static var equipment: CardEffect {
        .init(
            when: .cardPlayed,
            action: .equip,
            selectors: [
                .player(.actor),
                .card(.played)
            ]
        )
    }

    static var drawOnShot: CardEffect {
        .init(
            when: .shot,
            action: .draw,
            selectors: [
                .expectDraw("♥️")
            ]
        )
    }

    static var counterShootOnSuccessfulDraw: CardEffect {
        .init(
            when: .shot,
            action: .counterShoot,
            selectors: [
                .ifDrawResult(true),
                .player(.actor)
            ]
        )
    }

    static var drawOnTurnStarted: CardEffect {
        .init(
            when: .turnStarted,
            action: .draw,
            selectors: [
                .expectDraw("(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)")
            ]
        )
    }

    static var passInPlayOnSuccessfulDraw: CardEffect {
        .init(
            when: .turnStarted,
            action: .passInPlay,
            selectors: [
                .ifDrawResult(true),
                .player(.next),
                .card(.played)
            ]
        )
    }

    static var damage3OnFailedDraw: CardEffect {
        .init(
            when: .turnStarted,
            action: .damage,
            selectors: [
                .ifDrawResult(false),
                .amount(.value(3)),
                .player(.actor)
            ]
        )
    }

    static var discardOnFailedDraw: CardEffect {
        .init(
            when: .turnStarted,
            action: .discard,
            selectors: [
                .ifDrawResult(false),
                .player(.actor),
                .card(.played)
            ]
        )
    }

    static var weapon2: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setWeapon,
            selectors: [
                .amount(.value(2)),
                .player(.actor)
            ],
            until: .cardDiscarded
        )
    }

    static var weapon3: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setWeapon,
            selectors: [
                .amount(.value(3))
            ],
            until: .cardDiscarded
        )
    }

    static var weapon4: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setWeapon,
            selectors: [
                .amount(.value(4))
            ],
            until: .cardDiscarded
        )
    }

    static var weapon5: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setWeapon,
            selectors: [
                .amount(.value(5))
            ],
            until: .cardDiscarded
        )
    }

    static var weapon1: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setWeapon,
            selectors: [
                .amount(.value(1))
            ],
            until: .cardDiscarded
        )
    }

    static var unlimitedBang: CardEffect {
        .init(
            when: .cardPlayed,
            action: .setUnlimitedBang,
            until: .cardDiscarded
        )
    }
}

/*
 private extension Cards {
     static var scope: Card {
         Card.makeBuilder(name: .scope)
             .withRule(equipement)
             .withAttributes([.magnifying: 1])
             .build()
     }

     static var mustang: Card {
         Card.makeBuilder(name: .mustang)
             .withRule(equipement)
             .withAttributes([.remoteness: 1])
             .build()
     }

     // MARK: - Collectibles - Blue Handicap

     static var handicap: CardRule {
         CardEffect.handicap
             .target(.any)
             .on([.play])
     }

     static var jail: Card {
         Card.makeBuilder(name: .jail)
             .withRule(handicap)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.group {
                     CardEffect.draw
                         .repeat(.attr(.flippedCards))
                     CardEffect.luck(
                         .drawn,
                         regex: .regexEscapeFromJail,
                         onSuccess: .discard(.played),
                         onFailure: .group {
                             CardEffect.cancelTurn
                             CardEffect.discard(.played)
                             CardEffect.startTurn.target(.next(.actor))
                         }
                     )
                 }
                 .on([.startTurn])
             }
             .build()
     }

     // MARK: - Abilities

     static var endTurn: Card {
         Card.makeBuilder(name: .endTurn)
             .withRule {
                 CardEffect.group {
                     CardEffect.endTurn
                     CardEffect.startTurn
                         .target(.next(.actor))
                 }
                 .on([.play])
             }
             .build()
     }

     static var discardExcessHandOnEndTurn: Card {
         Card.makeBuilder(name: .discardExcessHandOnEndTurn)
             .withRule {
                 CardEffect.discard(.selectHand)
                     .repeat(.excessHand)
                     .on([.endTurn])
             }
             .build()
     }

     static var drawOnStartTurn: Card {
         Card.makeBuilder(name: .drawOnStartTurn)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.drawDeck
                     .repeat(.attr(.startTurnCards))
                     .on([.startTurn])
             }
             .build()
     }

     static var eliminateOnDamageLethal: Card {
         Card.makeBuilder(name: .eliminateOnDamageLethal)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.eliminate
                     .on([.damageLethal])
             }
             .build()
     }

     static var nextTurnOnEliminated: Card {
         Card.makeBuilder(name: .nextTurnOnEliminated)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.startTurn
                     .target(.next(.actor))
                     .on([.eliminated, .isYourTurn])
             }
             .build()
     }

     static var discardCardsOnEliminated: Card {
         Card.makeBuilder(name: .discardCardsOnEliminated)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.discard(.all)
                     .on([.eliminated])
             }
             .build()
     }

     static var discardPreviousWeaponOnPlayWeapon: Card {
         Card.makeBuilder(name: .discardPreviousWeaponOnPlayWeapon)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.discard(.previousInPlay(.weapon))
                     .on([.equipWeapon])
             }
             .build()
     }

     static var updateAttributesOnChangeInPlay: Card {
         Card.makeBuilder(name: .updateAttributesOnChangeInPlay)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.updateAttributes
                     .on([.changeInPlay])
             }
             .build()
     }

     static var playCounterCardsOnShot: Card {
         Card.makeBuilder(name: .playCounterCardsOnShot)
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.playCounterShootCards
                     .repeat(.shootMissesRequired)
                     .on([.shot])
             }
             .build()
     }

     // MARK: - Figures

     static var defaultPlayer: Card.Figure {
         Card.Figure(
             attributes: [
                 .startTurnCards: 2,
                 .weapon: 1,
                 .flippedCards: 1,
                 .bangsPerTurn: 1,
                 .requiredMissesForBang: 1
             ],
             abilities: [
                 .endTurn,
                 .discardExcessHandOnEndTurn,
                 .drawOnStartTurn,
                 .eliminateOnDamageLethal,
                 .discardCardsOnEliminated,
                 .nextTurnOnEliminated,
                 .updateAttributesOnChangeInPlay,
                 .discardPreviousWeaponOnPlayWeapon,
                 .playCounterCardsOnShot
             ]
         )
     }

     static var willyTheKid: Card {
         Card.makeBuilder(name: .willyTheKid)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4, .bangsPerTurn: 0])
             .build()
     }

     static var roseDoolan: Card {
         Card.makeBuilder(name: .roseDoolan)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4, .magnifying: 1])
             .build()
     }

     static var paulRegret: Card {
         Card.makeBuilder(name: .paulRegret)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 3, .remoteness: 1])
             .build()
     }

     static var jourdonnais: Card {
         Card.makeBuilder(name: .jourdonnais)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.group {
                     CardEffect.draw
                         .repeat(.attr(.flippedCards))
                     CardEffect.luck(
                         .drawn,
                         regex: .regexSaveByBarrel,
                         onSuccess: .counterShoot
                     )
                 }
                 .on([.shot])
             }
             .build()
     }

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

     static var bartCassidy: Card {
         Card.makeBuilder(name: .bartCassidy)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.drawDeck
                     .repeat(.damage)
                     .on([.damage])
             }
             .build()
     }

     static var elGringo: Card {
         Card.makeBuilder(name: .elGringo)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 3])
             .withRule {
                 CardEffect.steal(.selectHand)
                     .target(.offender)
                     .ignoreError()
                     .repeat(.damage)
                     .on([.damage])
             }
             .build()
     }

     static var suzyLafayette: Card {
         Card.makeBuilder(name: .suzyLafayette)
             .withPrototype(defaultPlayer)
             .withAttributes([.maxHealth: 4])
             .withPriorityIndex(priorities)
             .withRule {
                 CardEffect.drawDeck
                     .on([.handEmpty])
             }
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
