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

    static var heal_ifPlayersAtLeast3: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .if(.playersAtLeast(3)),
                .amount(.value(1))
            ],
            when: .cardPlayed
        )
    }

    static var heal_all: CardEffect {
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
                .if(.playedLessThan(.attr(.bangLimitPerTurn))),
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
                .if(.not(.draw("[2-9]♠️"))),
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
            when: .permanent
        )
    }

    static var setAttribute_weapon_3: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(3))
            ],
            when: .permanent
        )
    }

    static var setAttribute_weapon_4: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(4))
            ],
            when: .permanent
        )
    }

    static var setAttribute_weapon_5: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(5))
            ],
            when: .permanent
        )
    }

    static var setAttribute_weapon_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.weapon),
                .amount(.value(1))
            ],
            when: .permanent
        )
    }

    static var setAttribute_bangLimitPerTurn_0: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangLimitPerTurn),
                .amount(.value(0))
            ],
            when: .permanent
        )
    }

    static var setAttribute_bangLimitPerTurn_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.bangLimitPerTurn),
                .amount(.value(1))
            ],
            when: .permanent
        )
    }

    static var incrementAttribute_magnifying: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.magnifying)
            ],
            when: .permanent
        )
    }

    static var incrementAttribute_remoteness: CardEffect {
        .init(
            action: .incrementAttribute,
            selectors: [
                .attribute(.remoteness)
            ],
            when: .permanent
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

    static var heal_cost2HandCards: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand]), count: 2),
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

    static var setAttribute_startTurnCards_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.startTurnCards),
                .amount(.value(2))
            ],
            when: .cardPlayed
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

    static var setAttribute_drawCards_2: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.drawCards),
                .amount(.value(2))
            ],
            when: .cardPlayed
        )
    }

    static var setAttribute_missesRequiredForBang_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.requiredMissesForBang),
                .amount(.value(1))
            ],
            when: .permanent
        )
    }

    static var setAttribute_drawCards_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.drawCards),
                .amount(.value(1))
            ],
            when: .permanent
        )
    }

    static var setAttribute_playBangAsMissedAndViceVersa_1: CardEffect {
        .init(
            action: .setAttribute,
            selectors: [
                .attribute(.playBangAsMissedAndViceVersa),
                .amount(.value(1))
            ],
            when: .cardPlayed
        )
    }

    // MARK: - Dodge city

    static var shoot_any_atDistanceOf1: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .player(.any([.atDistance(.value(1))]))
            ],
            when: .cardPlayed
        )
    }

    static var drawDeck: CardEffect {
        .init(
            action: .drawDeck,
            when: .cardPlayed
        )
    }

    static var shoot_any_cost1HandCard: CardEffect {
        .init(
            action: .shoot,
            selectors: [
                .cost(.any([.fromHand])),
                .player(.any())
            ],
            when: .cardPlayed
        )
    }

    static var heal_2_cost1HandCard: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand])),
                .amount(.value(2))
            ],
            when: .cardPlayed
        )
    }

    static var heal_any_cost1HandCard: CardEffect {
        .init(
            action: .heal,
            selectors: [
                .cost(.any([.fromHand])),
                .player(.any()),
                .amount(.value(1))
            ],
            when: .cardPlayed
        )
    }

    static var steal_any_cost1HandCard: CardEffect {
        .init(
            action: .steal,
            selectors: [
                .cost(.any([.fromHand])),
                .player(.any()),
                .card(.any())
            ],
            when: .cardPlayed
        )
    }

    static var discard_all_cost1HandCard: CardEffect {
        .init(
            action: .discard,
            selectors: [
                .cost(.any([.fromHand])),
                .player(.all),
                .card(.any())
            ],
            when: .cardPlayed
        )
    }
}
/*
 {
     "name": "elenaFuente",
     "desc": "She may use any card in hand as Missed!.",
     "type": "figure",
     "attributes": {
       "bullets": 3,
       "playAs": { "": "missed" }
     }
   },
   {
     "name": "seanMallory",
     "desc": "He may hold in his hand up to 10 cards.",
     "type": "figure",
     "attributes": {
       "bullets": 3,
       "handLimit": 10
     }
   },
   {
     "name": "tequilaJoe",
     "desc": "Each time he plays a Beer, he regains 2 life points instead of 1.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["gain2HealthOnPlayBeer"]
   },
   {
     "name": "pixiePete",
     "desc": "During phase 1 of his turn, he draws 3 cards instead of 2.",
     "type": "figure",
     "attributes": {
       "bullets": 3,
       "silentAbility": "startTurnDrawing2Cards"
     },
     "abilities": ["startTurnDrawing3Cards"]
   },
   {
     "name": "billNoface",
     "desc": "He draws 1 card, plus 1 card for each wound he has.",
     "type": "figure",
     "attributes": {
       "bullets": 4,
       "silentAbility": "startTurnDrawing2Cards"
     },
     "abilities": ["startTurnDrawing1CardPlusWound"]
   },
   {
     "name": "gregDigger",
     "desc": "Each time another player is eliminated, he regains 2 life points.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["gain2HealthOnOtherEliminated"]
   },
   {
     "name": "herbHunter",
     "desc": "Each time another player is eliminated, he draws 2 extra cards.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["draw2CardsOnOtherEliminated"]
   },
   {
     "name": "mollyStark",
     "desc": "Each time she uses a card from her hand out of turn, she draw a card.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["drawCardOnPlayHandOutOfTurn"]
   },
   {
     "name": "joseDelgado",
     "desc": "Twice in his turn, he may discard a blue card from the hand to draw 2 cards.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["draw2CardsRequire1BlueCard"]
   },
   {
     "name": "chuckWengam",
     "desc": "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["draw2CardsRequire1Health"]
   },
   {
     "name": "docHolyday",
     "desc": "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!.",
     "type": "figure",
     "attributes": {
       "bullets": 4
     },
     "abilities": ["bangRequire2Cards"]
   },
   {
     "name": "patBrennan",
     "desc": "Instead of drawing normally, he may draw only one card in play in front of any one player.",
     "type": "figure",
     "attributes": {
       "bullets": 4,
       "silentAbility": "startTurnDrawing2Cards"
     },
     "abilities": ["startTurnChoosingDrawInPlay"]
   },
   {
     "name": "apacheKid",
     "desc": "Cards of Diamond played by other players do not affect him",
     "type": "figure",
     "attributes": {
       "bullets": 3,
       "silentCard": "♦️"
     }
   },
   {
     "name": "belleStar",
     "desc": "During her turn, cards in play in front of other players have no effect. ",
     "type": "figure",
     "attributes": {
       "bullets": 4,
       "silentInPlay": true
     }
   }
 */
