//
//  CardList.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
// swiftlint:disable no_magic_numbers closure_body_length file_length trailing_closure
import Game

public enum CardList {
    public static let all: [String: Card] = createCardDict(priorities) {
        beer
        saloon
        stagecoach
        wellsFargo
        catBalou
        panic
        generalStore
        bang
        missed
        gatling
        indians
        duel
        barrel
        dynamite
        jail
        schofield
        remington
        revCarabine
        winchester
        volcanic
        scope
        mustang
        endTurn
        drawOnSetTurn
        eliminateOnDamageLethal
        nextTurnOnEliminated
        discardCardsOnEliminated
        discardPreviousWeaponOnPlayWeapon
        updateAttributesOnChangeInPlay
        activateCounterCardsOnShot
        willyTheKid
        roseDoolan
        paulRegret
        jourdonnais
        slabTheKiller
        luckyDuke
        calamityJanet
        bartCassidy
        elGringo
        suzyLafayette
        vultureSam
        sidKetchum
        blackJack
        kitCarlson
        jesseJones
        pedroRamirez
    }

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
        .pedroRamirez
    ]
}

private extension CardList {
    // MARK: - Collectibles - Brown

    static var brown: Card {
        Card(String()) {
            CardEffect.discardPlayed
                .on([.play])
        }
    }

    static var beer: Card {
        Card(.beer, prototype: brown) {
            CardEffect.heal(1)
                .on([.play, .isPlayersAtLeast(3)])
        }
    }

    static var saloon: Card {
        Card(.saloon, prototype: brown) {
            CardEffect.heal(1)
                .target(.damaged)
                .on([.play])
        }
    }

    static var stagecoach: Card {
        Card(.stagecoach, prototype: brown) {
            CardEffect.drawDeck
                .repeat(2)
                .on([.play])
        }
    }

    static var wellsFargo: Card {
        Card(.wellsFargo, prototype: brown) {
            CardEffect.drawDeck
                .repeat(3)
                .on([.play])
        }
    }

    static var catBalou: Card {
        Card(.catBalou, prototype: brown) {
            CardEffect.discard(.selectAny, chooser: .actor)
                .target(.selectAny)
                .on([.play])
        }
    }

    static var panic: Card {
        Card(.panic, prototype: brown) {
            CardEffect.steal(.selectAny)
                .target(.selectAt(1))
                .on([.play])
        }
    }

    static var generalStore: Card {
        Card(.generalStore, prototype: brown) {
            CardEffect.group {
                CardEffect.discover
                    .repeat(.activePlayers)
                CardEffect.drawArena
                    .target(.all)
            }
            .on([.play])
        }
    }

    static var bang: Card {
        Card(.bang, prototype: brown) {
            CardEffect.shoot
                .target(.selectReachable)
                .on([.play, .isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))])
        }
    }

    static var missed: Card {
        Card(.missed, prototype: brown) {
            CardEffect.counterShoot
                .on([.play])
        }
    }

    static var gatling: Card {
        Card(.gatling, prototype: brown) {
            CardEffect.shoot
                .target(.others)
                .on([.play])
        }
    }

    static var indians: Card {
        Card(.indians, prototype: brown) {
            CardEffect.discard(.selectHandNamed(.bang))
                .force(otherwise: .damage(1))
                .target(.others)
                .on([.play])
        }
    }

    static var duel: Card {
        Card(.duel, prototype: brown) {
            CardEffect.discard(.selectHandNamed(.bang))
                .challenge(.actor, otherwise: .damage(1))
                .target(.selectAny)
                .on([.play])
        }
    }

    // MARK: - Collectibles - blue Equipment

    static var equipement: Card {
        Card(String()) {
            CardEffect.equip
                .on([.play])
        }
    }

    static var barrel: Card {
        Card(
            .barrel,
            prototype: equipement,
            rules: {
                CardEffect.group {
                    CardEffect.draw
                        .repeat(.attr(.flippedCards))
                    CardEffect.luck(
                        .topDiscard,
                        regex: .regexSaveByBarrel,
                        onSuccess: .counterShoot
                    )
                }
                .on([.shot])
            }
        )
    }

    static var dynamite: Card {
        Card(
            .dynamite,
            prototype: equipement,
            rules: {
                CardEffect.group {
                    CardEffect.draw
                        .repeat(.attr(.flippedCards))
                    CardEffect.luck(
                        .topDiscard,
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
        )
    }

    static var schofield: Card {
        Card(
            .schofield,
            prototype: equipement,
            attributes: [.weapon: 2]
        )
    }

    static var remington: Card {
        Card(
            .remington,
            prototype: equipement,
            attributes: [.weapon: 3]
        )
    }

    static var revCarabine: Card {
        Card(
            .revCarabine,
            prototype: equipement,
            attributes: [.weapon: 4]
        )
    }

    static var winchester: Card {
        Card(
            .winchester,
            prototype: equipement,
            attributes: [.weapon: 5]
        )
    }

    static var volcanic: Card {
        Card(
            .volcanic,
            prototype: equipement,
            attributes: [
                .weapon: 1,
                .bangsPerTurn: 0
            ]
        )
    }

    static var scope: Card {
        Card(
            .scope,
            prototype: equipement,
            attributes: [.scope: 1]
        )
    }

    static var mustang: Card {
        Card(.mustang, prototype: equipement, attributes: [.mustang: 1])
    }

    // MARK: - Collectibles - Blue Handicap

    static var handicap: Card {
        Card(String()) {
            CardEffect.handicap
                .target(.selectAny)
                .on([.play])
        }
    }

    static var jail: Card {
        Card(.jail, prototype: handicap) {
            CardEffect.group {
                CardEffect.draw
                    .repeat(.attr(.flippedCards))
                CardEffect.luck(
                    .topDiscard,
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
    }

    // MARK: - Abilities

    static var endTurn: Card {
        Card(.endTurn) {
            CardEffect.group {
                CardEffect.discard(.selectHand)
                    .repeat(.excessHand)
                CardEffect.setTurn
                    .target(.next)
            }
            .on([.play])
        }
    }

    static var drawOnSetTurn: Card {
        Card(.drawOnSetTurn) {
            CardEffect.drawDeck
                .repeat(.attr(.startTurnCards))
                .on([.setTurn])
        }
    }

    static var eliminateOnDamageLethal: Card {
        Card(.eliminateOnDamageLethal) {
            CardEffect.eliminate
                .on([.damageLethal])
        }
    }

    static var nextTurnOnEliminated: Card {
        Card(.nextTurnOnEliminated) {
            CardEffect.setTurn
                .target(.next)
                .on([.eliminated, .isYourTurn])
        }
    }

    static var discardCardsOnEliminated: Card {
        Card(.discardCardsOnEliminated) {
            CardEffect.discard(.all)
                .on([.eliminated])
        }
    }

    static var discardPreviousWeaponOnPlayWeapon: Card {
        Card(.discardPreviousWeaponOnPlayWeapon) {
            CardEffect.discard(.previousInPlayWithAttribute(.weapon))
                .on([.playWeapon])
        }
    }

    static var updateAttributesOnChangeInPlay: Card {
        Card(.updateAttributesOnChangeInPlay) {
            CardEffect.updateAttributes
                .on([.changeInPlay])
        }
    }

    static var activateCounterCardsOnShot: Card {
        Card(.activateCounterCardsOnShot) {
            CardEffect.activateCounterCards
                .on([.shot])
        }
    }

    // MARK: - Figures

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
                .activateCounterCardsOnShot
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
        Card(.willyTheKid, prototype: pDefault, attributes: [.maxHealth: 4, .bangsPerTurn: 0])
    }

    static var roseDoolan: Card {
        Card(.roseDoolan, prototype: pDefault, attributes: [.maxHealth: 4, .scope: 1])
    }

    static var paulRegret: Card {
        Card(.paulRegret, prototype: pDefault, attributes: [.maxHealth: 3, .mustang: 1])
    }

    static var jourdonnais: Card {
        Card(.jourdonnais, prototype: pDefault, attributes: [.maxHealth: 4]) {
            CardEffect.group {
                CardEffect.draw
                    .repeat(.attr(.flippedCards))
                CardEffect.luck(
                    .topDiscard,
                    regex: .regexSaveByBarrel,
                    onSuccess: .counterShoot
                )
            }
            .on([.shot])
        }
    }

    static var slabTheKiller: Card {
        Card(.slabTheKiller, prototype: pDefault, attributes: [.maxHealth: 4])
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
                CardAlias(card: .bang, regex: .missed, playReqs: [.play]),
                CardAlias(card: .missed, regex: .bang, playReqs: [.shot])
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
            CardEffect.steal(.randomHand)
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
            .on([.play, .isHandAtLeast(2)])
        }
    }

    static var blackJack: Card {
        Card(.blackJack, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
            CardEffect.group {
                CardEffect.drawDeck
                    .repeat(.attr(.startTurnCards))
                CardEffect.luck(.lastHand, regex: .regexDrawAnotherCard, onSuccess: .drawDeck)
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
                CardEffect.steal(.randomHand)
                    .target(.selectAny)
                    .force(otherwise: .drawDeck)
                CardEffect.drawDeck
                    .repeat(.add(-1, attr: .startTurnCards))
            }
            .on([.setTurn])
        }
    }
}

private extension CardList {
    /// Order in which triggered effects are dispatched
    /// sorted from highest to lowest priority
    static let priorities: [String] = [
        .dynamite,
        .jail,
        .drawOnSetTurn,
        .discardPreviousWeaponOnPlayWeapon,
        .updateAttributesOnChangeInPlay,
        .eliminateOnDamageLethal,
        .vultureSam,
        .discardCardsOnEliminated,
        .nextTurnOnEliminated
    ]
}

private func createCardDict(
    _ priorities: [String],
    @CardBuilder content: () -> [Card]
) -> [String: Card] {
    content().reduce(into: [String: Card]()) { result, card in
        let priority = priorities.firstIndex(of: card.name) ?? Int.max
        return result[card.name] = card.withPriority(priority)
    }
}

private extension String {
    // https://regex101.com/
    static let regexSaveByBarrel = "♥️"
    static let regexEscapeFromJail = "♥️"
    static let regexPassDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
    static let regexDrawAnotherCard = "(♥️)|(♦️)"
}
