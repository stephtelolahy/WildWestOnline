//
//  Cards.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
// swiftlint:disable no_magic_numbers file_length trailing_closure
import GameCore

public enum Cards {
    public static let all: [String: Card] = createCardDict(
        priorities,
        content: [
            beer,
            saloon,
            stagecoach,
            wellsFargo,
            catBalou,
            panic,
            generalStore,
            bang,
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
            drawOnSetTurn,
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
            blackJack,
            kitCarlson,
            jesseJones,
            pedroRamirez,
            custom
        ]
    )

    public static let figures: [String] = [
        .willyTheKid,
        .roseDoolan,
        .paulRegret,
        .jourdonnais,
        .slabTheKiller,
        .luckyDuke,
        .calamityJanet,
        .bartCassidy,
        .elGringo,
        .suzyLafayette,
        .vultureSam,
        .sidKetchum,
        .blackJack,
        .kitCarlson,
        .jesseJones,
        .pedroRamirez,
        .custom
    ]
}

private extension Cards {
    // MARK: - Collectibles - Brown

    static var brown: CardRule {
        CardEffect.discardPlayed
            .on([.play])
    }

    static var beer: Card {
        Card.makeBuilder(name: .beer)
            .withPrototype(brown)
            .withRule {
                CardEffect.heal(1)
                    .on([.play, .isPlayersAtLeast(3)])
            }
            .build()
    }

    static var saloon: Card {
        Card.makeBuilder(name: .saloon)
            .withPrototype(brown)
            .withRule {
                CardEffect.heal(1)
                    .target(.damaged)
                    .on([.play])
            }
            .build()
    }

    static var stagecoach: Card {
        Card.makeBuilder(name: .stagecoach)
            .withPrototype(brown)
            .withRule(content: {
                CardEffect.drawDeck
                    .repeat(2)
                    .on([.play])
            })
            .build()
    }

    static var wellsFargo: Card {
        Card.makeBuilder(name: .wellsFargo)
            .withPrototype(brown)
            .withRule {
                CardEffect.drawDeck
                    .repeat(3)
                    .on([.play])
            }
            .build()
    }

    static var catBalou: Card {
        Card.makeBuilder(name: .catBalou)
            .withPrototype(brown)
            .withRule {
                CardEffect.discard(.selectAny, chooser: .actor)
                    .target(.selectAny)
                    .on([.play])
            }
            .build()
    }

    static var panic: Card {
        Card.makeBuilder(name: .panic)
            .withPrototype(brown)
            .withRule {
                CardEffect.steal(.selectAny)
                    .target(.selectAt(1))
                    .on([.play])
            }
            .build()
    }

    static var generalStore: Card {
        Card.makeBuilder(name: .generalStore)
            .withPrototype(brown)
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

    static var bang: Card {
        Card.makeBuilder(name: .bang)
            .withPrototype(brown)
            .withRule {
                CardEffect.shoot
                    .target(.selectReachable)
                    .on([.play, .isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))])
            }
            .build()
    }

    static var missed: Card {
        Card.makeBuilder(name: .missed)
            .withPrototype(brown)
            .withRule {
                CardEffect.counterShoot
                    .on([.play])
            }
            .build()
    }

    static var gatling: Card {
        Card.makeBuilder(name: .gatling)
            .withPrototype(brown)
            .withRule {
                CardEffect.shoot
                    .target(.others)
                    .on([.play])
            }
            .build()
    }

    static var indians: Card {
        Card.makeBuilder(name: .indians)
            .withPrototype(brown)
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
            .withPrototype(brown)
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
            .withPrototype(equipement)
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
            .withPrototype(equipement)
            .withPriorityIndex(priorities)
            .withRule {
                CardEffect.group {
                    CardEffect.draw
                        .repeat(.attr(.flippedCards))
                    CardEffect.luck(
                        .drawn,
                        regex: .regexPassDynamite,
                        onSuccess: .passInPlay(.played, toPlayer: .next),
                        onFailure: .group([
                            .damage(3),
                            .discard(.played)
                        ])
                    )
                }
                .on([.setTurn])
            }
            .build()
    }

    static var schofield: Card {
        Card.makeBuilder(name: .schofield)
            .withPrototype(equipement)
            .withAttributes([.weapon: 2])
            .build()
    }

    static var remington: Card {
        Card.makeBuilder(name: .remington)
            .withPrototype(equipement)
            .withAttributes([.weapon: 3])
            .build()
    }

    static var revCarabine: Card {
        Card.makeBuilder(name: .revCarabine)
            .withPrototype(equipement)
            .withAttributes([.weapon: 4])
            .build()
    }

    static var winchester: Card {
        Card.makeBuilder(name: .winchester)
            .withPrototype(equipement)
            .withAttributes([.weapon: 5])
            .build()
    }

    static var volcanic: Card {
        Card.makeBuilder(name: .volcanic)
            .withPrototype(equipement)
            .withAttributes([
                .weapon: 1,
                .bangsPerTurn: 0
            ])
            .build()
    }

    static var scope: Card {
        Card.makeBuilder(name: .scope)
            .withPrototype(equipement)
            .withAttributes([.magnifying: 1])
            .build()
    }

    static var mustang: Card {
        Card.makeBuilder(name: .mustang)
            .withPrototype(equipement)
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
            .withPrototype(handicap)
            .withPriorityIndex(priorities)
            .withRule {
                CardEffect.group {
                    CardEffect.draw
                        .repeat(.attr(.flippedCards))
                    CardEffect.luck(
                        .drawn,
                        regex: .regexEscapeFromJail,
                        onSuccess: .discard(.played),
                        onFailure: .group([
                            .cancelTurn,
                            .discard(.played),
                            .setTurn.target(.next)
                        ])
                    )
                }
                .on([.setTurn])
            }
            .build()
    }

    // MARK: - Abilities

    static var endTurn: Card {
        Card.makeBuilder(name: .endTurn)
            .withRule {
                CardEffect.group {
                    CardEffect.discard(.selectHand)
                        .repeat(.excessHand)
                    CardEffect.setTurn
                        .target(.next)
                }
                .on([.play])
            }
            .build()
    }

    static var drawOnSetTurn: Card {
        Card.makeBuilder(name: .drawOnSetTurn)
            .withPriorityIndex(priorities)
            .withRule {
                CardEffect.drawDeck
                    .repeat(.attr(.startTurnCards))
                    .on([.setTurn])
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
                CardEffect.setTurn
                    .target(.next)
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
                CardEffect.playCounterCards
                    .on([.shot])
            }
            .build()
    }

    // MARK: - Figures

    static var defaultPlayer: Card.Figure {
        .init(
            attributes: [
                .startTurnCards: 2,
                .weapon: 1,
                .flippedCards: 1,
                .bangsPerTurn: 1
            ],
            abilities: [
                .endTurn,
                .drawOnSetTurn,
                .eliminateOnDamageLethal,
                .discardCardsOnEliminated,
                .nextTurnOnEliminated,
                .updateAttributesOnChangeInPlay,
                .discardPreviousWeaponOnPlayWeapon,
                .playCounterCardsOnShot
            ]
        )
    }

    @available(*, deprecated, message: "Use defaultPlayer")
    static var pDefault: Card {
        Card(
            String(),
            abilities: [
                .endTurn,
                .drawOnSetTurn,
                .eliminateOnDamageLethal,
                .discardCardsOnEliminated,
                .nextTurnOnEliminated,
                .updateAttributesOnChangeInPlay,
                .discardPreviousWeaponOnPlayWeapon,
                .playCounterCardsOnShot
            ],
            attributes: [
                .startTurnCards: 2,
                .weapon: 1,
                .flippedCards: 1,
                .bangsPerTurn: 1
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
            .withAttributes([.maxHealth: 4])
            .build()
    }

    static var luckyDuke: Card {
        Card(.luckyDuke, prototype: pDefault, attributes: [.maxHealth: 4, .flippedCards: 2])
    }

    static var calamityJanet: Card {
        Card(
            .calamityJanet,
            prototype: pDefault,
            attributes: [.maxHealth: 4],
            alias: [
                CardAlias(playedRegex: .missed, as: .bang, playReqs: [.isYourTurn]),
                CardAlias(playedRegex: .bang, as: .missed, playReqs: [.isNot(.isYourTurn)])
            ]
        )
    }

    static var bartCassidy: Card {
        Card(.bartCassidy, prototype: pDefault, attributes: [.maxHealth: 4]) {
            CardEffect.drawDeck
                .repeat(.damage)
                .on([.damage])
        }
    }

    static var elGringo: Card {
        Card(.elGringo, prototype: pDefault, attributes: [.maxHealth: 3]) {
            CardEffect.steal(.selectHand)
                .target(.offender)
                .ignoreError()
                .repeat(.damage)
                .on([.damage])
        }
    }

    static var suzyLafayette: Card {
        Card(.suzyLafayette, prototype: pDefault, attributes: [.maxHealth: 4]) {
            CardEffect.drawDeck
                .on([.handEmpty])
        }
    }

    static var vultureSam: Card {
        Card(.vultureSam, prototype: pDefault, attributes: [.maxHealth: 4]) {
            CardEffect.steal(.all)
                .target(.eliminated)
                .on([.anotherEliminated])
        }
    }

    static var sidKetchum: Card {
        Card(.sidKetchum, prototype: pDefault, attributes: [.maxHealth: 4]) {
            CardEffect.group {
                CardEffect.discard(.selectHand)
                    .repeat(2)
                CardEffect.heal(1)
            }
            .on([.play])
        }
    }

    static var blackJack: Card {
        Card(.blackJack, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
            CardEffect.group {
                CardEffect.drawDeck
                    .repeat(.attr(.startTurnCards))
                CardEffect.revealLastHand
                CardEffect.luck(.drawnHand, regex: .regexDrawAnotherCard, onSuccess: .drawDeck)
            }
            .on([.setTurn])
        }
    }

    static var kitCarlson: Card {
        Card(.kitCarlson, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
            CardEffect.group {
                CardEffect.drawDeck
                    .repeat(.add(1, attr: .startTurnCards))
                CardEffect.putBack(among: .add(1, attr: .startTurnCards))
            }
            .on([.setTurn])
        }
    }

    static var jesseJones: Card {
        Card(.jesseJones, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
            CardEffect.group {
                CardEffect.drawDiscard
                    .force(otherwise: .drawDeck)
                CardEffect.drawDeck
                    .repeat(.add(-1, attr: .startTurnCards))
            }
            .on([.setTurn])
        }
    }

    static var pedroRamirez: Card {
        Card(.pedroRamirez, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
            CardEffect.group {
                CardEffect.steal(.selectHand)
                    .target(.selectAny)
                    .force(otherwise: .drawDeck)
                CardEffect.drawDeck
                    .repeat(.add(-1, attr: .startTurnCards))
            }
            .on([.setTurn])
        }
    }

    static var custom: Card {
        Card(
            .custom,
            prototype: pDefault,
            abilities: [
                .willyTheKid,
                .roseDoolan,
                .paulRegret,
                .jourdonnais,
                .slabTheKiller,
                .luckyDuke,
                .calamityJanet,
                .bartCassidy,
                .elGringo,
                .suzyLafayette,
                .vultureSam,
                .sidKetchum
//                .blackJack,
//                .kitCarlson,
//                .jesseJones,
//                .pedroRamirez
            ],
            attributes: [.maxHealth: 4]
        )
    }
}

private extension Cards {
    /// Order in which triggered effects are dispatched
    /// sorted from highest to lowest priority
    static let priorities: [String] = [
        // MARK: - setTurn
        .dynamite,
        .jail,
        .drawOnSetTurn,
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

private func createCardDict(
    _ priorities: [String],
    content: [Card]
) -> [String: Card] {
    content.reduce(into: [String: Card]()) { result, card in
        let priority = priorities.firstIndex(of: card.name) ?? Int.max
        return result[card.name] = card.withPriority(priority)
    }
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
}
