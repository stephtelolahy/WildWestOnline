//
//  Cards+Old.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
// swiftlint:disable no_magic_numbers file_length
import GameCore

@available(*, deprecated, message: "use new cards")
enum CardsOld {
    static let all: [String: Card] = [
        beer,
        saloon,
        stagecoach,
        wellsFargo,
        catBalou,
        panic,
        generalStore,
//        bang,
        missed,
        gatling,
        indians,
        duel,
        barrel,
        dynamite,
        jail,
        schofield,
        remington,
        revCarabine,
        winchester,
        volcanic,
        scope,
        mustang,
        endTurn,
        discardExcessHandOnEndTurn,
//        drawOnStartTurn,
        eliminateOnDamageLethal,
        nextTurnOnEliminated,
        discardCardsOnEliminated,
        discardPreviousWeaponOnPlayWeapon,
        updateAttributesOnChangeInPlay,
        playCounterCardsOnShot,
        willyTheKid,
        roseDoolan,
        paulRegret,
        jourdonnais,
        slabTheKiller,
        luckyDuke,
        calamityJanet,
        bartCassidy,
        elGringo,
        suzyLafayette,
        vultureSam,
        sidKetchum,
//        blackJack,
//        kitCarlson,
//        jesseJones,
//        pedroRamirez,
        custom
    ].reduce(into: [:]) { result, card in
        result[card.name] = card
    }
}

private extension CardsOld {
    // MARK: - Collectibles - Brown

    static var brown: CardRule {
        CardEffect.discardPlayed
            .on([.play])
    }

    static var beer: Card {
        Card.makeBuilder(name: .beer)
            .withRule(brown)
            .withRule {
                CardEffect.heal(1)
                    .on([.play, .isPlayersAtLeast(3)])
            }
            .build()
    }

    static var saloon: Card {
        Card.makeBuilder(name: .saloon)
            .withRule(brown)
            .withRule {
                CardEffect.heal(1)
                    .target(.damaged)
                    .on([.play])
            }
            .build()
    }

    static var stagecoach: Card {
        Card.makeBuilder(name: .stagecoach)
            .withRule(brown)
            .withRule {
                CardEffect.drawDeck
                    .repeat(2)
                    .on([.play])
            }
            .build()
    }

    static var wellsFargo: Card {
        Card.makeBuilder(name: .wellsFargo)
            .withRule(brown)
            .withRule {
                CardEffect.drawDeck
                    .repeat(3)
                    .on([.play])
            }
            .build()
    }

    static var catBalou: Card {
        Card.makeBuilder(name: .catBalou)
            .withRule(brown)
            .withRule {
                CardEffect.discard(.selectAny, chooser: .actor)
                    .target(.selectAny)
                    .on([.play])
            }
            .build()
    }

    static var panic: Card {
        Card.makeBuilder(name: .panic)
            .withRule(brown)
            .withRule {
                CardEffect.steal(.selectAny)
                    .target(.selectAt(1))
                    .on([.play])
            }
            .build()
    }

    static var generalStore: Card {
        Card.makeBuilder(name: .generalStore)
            .withRule(brown)
            .withRule {
                CardEffect.group {
                    CardEffect.discover
                        .repeat(.activePlayers)
                    CardEffect.drawArena
                        .target(.all)
                }
                .on([.play])
            }
            .build()
    }

//    static var bang: Card {
//        Card.makeBuilder(name: .bang)
//            .withRule(brown)
//            .withRule {
//                CardEffect.shoot(missesRequired: .attr(.missesRequiredForBang))
//                    .target(.selectReachable)
//                    .on([.play, .isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))])
//            }
//            .build()
//    }

    static var missed: Card {
        Card.makeBuilder(name: .missed)
            .withRule(brown)
            .withRule {
                CardEffect.counterShoot
                    .on([.play])
            }
            .build()
    }

    static var gatling: Card {
        Card.makeBuilder(name: .gatling)
            .withRule(brown)
            .withRule {
                CardEffect.shoot(missesRequired: .exact(1))
                    .target(.others)
                    .on([.play])
            }
            .build()
    }

    static var indians: Card {
        Card.makeBuilder(name: .indians)
            .withRule(brown)
            .withRule {
                CardEffect.discard(.selectHandNamed(.bang))
                    .force(otherwise: .damage(1))
                    .target(.others)
                    .on([.play])
            }
            .build()
    }

    static var duel: Card {
        Card.makeBuilder(name: .duel)
            .withRule(brown)
            .withRule {
                CardEffect.discard(.selectHandNamed(.bang))
                    .challenge(.actor, otherwise: .damage(1))
                    .target(.selectAny)
                    .on([.play])
            }
            .build()
    }

    // MARK: - Collectibles - blue Equipment

    static var equipement: CardRule {
        CardEffect.equip
            .on([.play])
    }

    static var barrel: Card {
        Card.makeBuilder(name: .barrel)
            .withRule(equipement)
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

    static var dynamite: Card {
        Card.makeBuilder(name: .dynamite)
            .withRule(equipement)
            .withPriorityIndex(priorities)
            .withRule {
                CardEffect.group {
                    CardEffect.draw
                        .repeat(.attr(.flippedCards))
                    CardEffect.luck(
                        .drawn,
                        regex: .regexPassDynamite,
                        onSuccess: .passInPlay(.played, toPlayer: .next(.actor)),
                        onFailure: .group {
                            CardEffect.damage(3)
                            CardEffect.discard(.played)
                        }
                    )
                }
                .on([.startTurn])
            }
            .build()
    }

    static var schofield: Card {
        Card.makeBuilder(name: .schofield)
            .withRule(equipement)
            .withAttributes([.weapon: 2])
            .build()
    }

    static var remington: Card {
        Card.makeBuilder(name: .remington)
            .withRule(equipement)
            .withAttributes([.weapon: 3])
            .build()
    }

    static var revCarabine: Card {
        Card.makeBuilder(name: .revCarabine)
            .withRule(equipement)
            .withAttributes([.weapon: 4])
            .build()
    }

    static var winchester: Card {
        Card.makeBuilder(name: .winchester)
            .withRule(equipement)
            .withAttributes([.weapon: 5])
            .build()
    }

    static var volcanic: Card {
        Card.makeBuilder(name: .volcanic)
            .withRule(equipement)
            .withAttributes([
                .weapon: 1,
                .bangsPerTurn: 0
            ])
            .build()
    }

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
            .target(.selectAny)
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
            .withRule(abilityRule)
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

//    static var drawOnStartTurn: Card {
//        Card.makeBuilder(name: .drawOnStartTurn)
//            .withPriorityIndex(priorities)
//            .withRule {
//                CardEffect.drawDeck
//                    .repeat(.attr(.startTurnCards))
//                    .on([.startTurn])
//            }
//            .build()
//    }

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
                .missesRequiredForBang: 1
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
            .withAttributes([.maxHealth: 4, .missesRequiredForBang: 2])
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

    static var abilityRule: CardRule {
        CardEffect.playAbility
            .on([.play])
    }

    static var sidKetchum: Card {
        Card.makeBuilder(name: .sidKetchum)
            .withPrototype(defaultPlayer)
            .withAttributes([.maxHealth: 4])
            .withRule(abilityRule)
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

//    static var blackJack: Card {
//        Card.makeBuilder(name: .blackJack)
//            .withPrototype(defaultPlayer)
//            .withPriorityIndex(priorities)
//            .withAttributes([.maxHealth: 4])
//            .withoutAbility(.drawOnStartTurn)
//            .withRule {
//                CardEffect.group {
//                    CardEffect.drawDeck
//                        .repeat(.attr(.startTurnCards))
//                    CardEffect.revealLastHand
//                    CardEffect.luck(.drawnHand, regex: .regexDrawAnotherCard, onSuccess: .drawDeck)
//                }
//                .on([.startTurn])
//            }
//            .build()
//    }

//    static var kitCarlson: Card {
//        Card.makeBuilder(name: .kitCarlson)
//            .withPrototype(defaultPlayer)
//            .withPriorityIndex(priorities)
//            .withAttributes([.maxHealth: 4])
//            .withoutAbility(.drawOnStartTurn)
//            .withRule {
//                CardEffect.group {
//                    CardEffect.drawDeck
//                        .repeat(.add(1, attr: .startTurnCards))
//                    CardEffect.putBack(among: .add(1, attr: .startTurnCards))
//                }
//                .on([.startTurn])
//            }
//            .build()
//    }

//    static var jesseJones: Card {
//        Card.makeBuilder(name: .jesseJones)
//            .withPrototype(defaultPlayer)
//            .withPriorityIndex(priorities)
//            .withAttributes([.maxHealth: 4])
//            .withoutAbility(.drawOnStartTurn)
//            .withRule {
//                CardEffect.group {
//                    CardEffect.drawDiscard
//                        .force(otherwise: .drawDeck)
//                    CardEffect.drawDeck
//                        .repeat(.add(-1, attr: .startTurnCards))
//                }
//                .on([.startTurn])
//            }
//            .build()
//    }

//    static var pedroRamirez: Card {
//        Card.makeBuilder(name: .pedroRamirez)
//            .withPrototype(defaultPlayer)
//            .withPriorityIndex(priorities)
//            .withAttributes([.maxHealth: 4])
//            .withoutAbility(.drawOnStartTurn)
//            .withRule {
//                CardEffect.group {
//                    CardEffect.steal(.selectHand)
//                        .target(.selectAny)
//                        .force(otherwise: .drawDeck)
//                    CardEffect.drawDeck
//                        .repeat(.add(-1, attr: .startTurnCards))
//                }
//                .on([.startTurn])
//            }
//            .build()
//    }

    static var custom: Card {
        Card.makeBuilder(name: .custom)
            .withPrototype(defaultPlayer)
            .withAttributes([
                    .maxHealth: 4,
                    .startTurnCards: 3,
                    .missesRequiredForBang: 2,
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

private extension CardsOld {
    /// Order in which triggered effects are dispatched
    /// sorted from highest to lowest priority
    static let priorities: [String] = [
        // MARK: - startTurn
        .dynamite,
        .jail,
        .drawOnStartTurn,
        .blackJack,
        .kitCarlson,
        .jesseJones,
        .pedroRamirez,
        // MARK: - changeInPlay
        .discardPreviousWeaponOnPlayWeapon,
        .updateAttributesOnChangeInPlay,
        // MARK: - eliminated
        .vultureSam,
        .discardCardsOnEliminated,
        .nextTurnOnEliminated,
        // MARK: - shot
        .barrel,
        .jourdonnais,
        .playCounterCardsOnShot
    ]
}

/// Card effect regex
/// https://regex101.com/
private extension String {
    static let regexSaveByBarrel = "♥️"
    static let regexEscapeFromJail = "♥️"
    static let regexPassDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
    static let regexDrawAnotherCard = "(♥️)|(♦️)"
}

/// Dynamic attribute names
public extension String {
    /// Cards to draw at beginning of turn
    static let startTurnCards = "startTurnCards"

    /// Number of bangs per turn
    /// Unlimited when value is 0
    static let bangsPerTurn = "bangsPerTurn"

    /// Number of misses required to counter his bang
    static let missesRequiredForBang = "missesRequiredForBang"
}
