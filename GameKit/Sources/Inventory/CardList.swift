//
//  CardList.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
// swiftlint:disable line_length no_magic_numbers closure_body_length file_length
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
        updateGameOverOnEliminated
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

    static let beer = Card(.beer) {
        CardEffect.heal(1)
            .on([.playImmediate, .isPlayersAtLeast(3)])
    }

    static let saloon = Card(.saloon) {
        CardEffect.heal(1)
            .target(.damaged)
            .on([.playImmediate])
    }

    static let stagecoach = Card(.stagecoach) {
        CardEffect.drawDeck
            .repeat(2)
            .on([.playImmediate])
    }

    static let wellsFargo = Card(.wellsFargo) {
        CardEffect.drawDeck
            .repeat(3)
            .on([.playImmediate])
    }

    static let catBalou = Card(.catBalou) {
        CardEffect.discard(.selectAny, chooser: .actor)
            .target(.selectAny)
            .on([.playImmediate])
    }

    static let panic = Card(.panic) {
        CardEffect.steal(.selectAny)
            .target(.selectAt(1))
            .on([.playImmediate])
    }

    static let generalStore = Card(.generalStore) {
        CardEffect.group {
            CardEffect.discover
                .repeat(.activePlayers)
            CardEffect.drawArena
                .target(.all)
        }
        .on([.playImmediate])
    }

    static let bang = Card(.bang) {
        CardEffect.shoot
            .target(.selectReachable)
            .on([.playImmediate, .isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))])
    }

    static let missed = Card(.missed) {
        CardEffect.counterShoot
            .on([.playImmediate])
    }

    static let gatling = Card(.gatling) {
        CardEffect.shoot
            .target(.others)
            .on([.playImmediate])
    }

    static let indians = Card(.indians) {
        CardEffect.discard(.selectHandNamed(.bang))
            .force(otherwise: .damage(1))
            .target(.others)
            .on([.playImmediate])
    }

    static let duel = Card(.duel) {
        CardEffect.discard(.selectHandNamed(.bang))
            .challenge(.actor, otherwise: .damage(1))
            .target(.selectAny)
            .on([.playImmediate])
    }

    // MARK: - Collectibles - Handicap

    static let jail = Card(.jail) {
        CardEffect.nothing
            .target(.selectAny)
            .on([.playHandicap])
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

    // MARK: - Collectibles - Equipment

    static let equipement = Card(String()) {
        CardEffect.nothing
            .on([.playEquipment])
    }

    static let barrel = Card(.barrel, prototype: equipement) {
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

    static let dynamite = Card(.dynamite, prototype: equipement) {
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

    static let schofield = Card(.schofield, prototype: equipement, attributes: [.weapon: 2])

    static let remington = Card(.remington, prototype: equipement, attributes: [.weapon: 3])

    static let revCarabine = Card(.revCarabine, prototype: equipement, attributes: [.weapon: 4])

    static let winchester = Card(.winchester, prototype: equipement, attributes: [.weapon: 5])

    static let volcanic = Card(.volcanic, prototype: equipement, attributes: [.weapon: 1, .bangsPerTurn: 0])

    static let scope = Card(.scope, prototype: equipement, attributes: [.scope: 1])

    static let mustang = Card(.mustang, prototype: equipement, attributes: [.mustang: 1])

    // MARK: - Abilities

    static let endTurn = Card(.endTurn) {
        CardEffect.group {
            CardEffect.discard(.selectHand)
                .repeat(.excessHand)
            CardEffect.setTurn
                .target(.next)
        }
        .on([.playAbility])
    }

    static let drawOnSetTurn = Card(.drawOnSetTurn) {
        CardEffect.drawDeck
            .repeat(.attr(.startTurnCards))
            .on([.setTurn])
    }

    static let eliminateOnDamageLethal = Card(.eliminateOnDamageLethal) {
        CardEffect.eliminate
            .on([.damageLethal])
    }

    static let nextTurnOnEliminated = Card(.nextTurnOnEliminated) {
        CardEffect.setTurn
            .target(.next)
            .on([.eliminated, .isYourTurn])
    }

    static let discardCardsOnEliminated = Card(.discardCardsOnEliminated) {
        CardEffect.discard(.all)
            .on([.eliminated])
    }

    static let discardPreviousWeaponOnPlayWeapon = Card(.discardPreviousWeaponOnPlayWeapon) {
        CardEffect.discard(.previousInPlayWithAttribute(.weapon))
            .on([.playWeapon])
    }

    static let updateAttributesOnChangeInPlay = Card(.updateAttributesOnChangeInPlay) {
        CardEffect.updateAttributes
            .on([.changeInPlay])
    }

    static let activateCounterCardsOnShot = Card(.activateCounterCardsOnShot) {
        CardEffect.activateCounterCards
            .on([.shot])
    }

    static let updateGameOverOnEliminated = Card(.updateGameOverOnEliminated) {
        CardEffect.updateGameOver
            .on([.eliminated])
    }

    // MARK: - Figures

    static let pDefault = Card(
        String(),
        abilities: [
            .endTurn,
            .drawOnSetTurn,
            .eliminateOnDamageLethal,
            .discardCardsOnEliminated,
            .nextTurnOnEliminated,
            .updateAttributesOnChangeInPlay,
            .discardPreviousWeaponOnPlayWeapon,
            .activateCounterCardsOnShot,
            .updateGameOverOnEliminated
        ],
        attributes: [
            .startTurnCards: 2,
            .weapon: 1,
            .flippedCards: 1,
            .bangsPerTurn: 1
        ]
    )

    static let willyTheKid = Card(.willyTheKid, prototype: pDefault, attributes: [.maxHealth: 4, .bangsPerTurn: 0])

    static let roseDoolan = Card(.roseDoolan, prototype: pDefault, attributes: [.maxHealth: 4, .scope: 1])

    static let paulRegret = Card(.paulRegret, prototype: pDefault, attributes: [.maxHealth: 3, .mustang: 1])

    static let jourdonnais = Card(.jourdonnais, prototype: pDefault, attributes: [.maxHealth: 4]) {
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

    static let slabTheKiller = Card(.slabTheKiller, prototype: pDefault, attributes: [.maxHealth: 4])

    static let luckyDuke = Card(.luckyDuke, prototype: pDefault, attributes: [.maxHealth: 4, .flippedCards: 2])

    private static let playBangAsMissedAndViceVersa: [CardAlias] = [
        CardAlias(card: .bang, regex: .missed, playReqs: [.play]),
        CardAlias(card: .missed, regex: .bang, playReqs: [.shot])
    ]
    static let calamityJanet = Card(.calamityJanet, prototype: pDefault, attributes: [.maxHealth: 4], alias: playBangAsMissedAndViceVersa)

    static let bartCassidy = Card(.bartCassidy, prototype: pDefault, attributes: [.maxHealth: 4]) {
        CardEffect.drawDeck
            .repeat(.damage)
            .on([.damage])
    }

    static let elGringo = Card(.elGringo, prototype: pDefault, attributes: [.maxHealth: 3]) {
        CardEffect.steal(.randomHand)
            .target(.offender)
            .ignoreError()
            .repeat(.damage)
            .on([.damage])
    }

    static let suzyLafayette = Card(.suzyLafayette, prototype: pDefault, attributes: [.maxHealth: 4]) {
        CardEffect.drawDeck
            .on([.handEmpty])
    }

    static let vultureSam = Card(.vultureSam, prototype: pDefault, attributes: [.maxHealth: 4]) {
        CardEffect.steal(.all)
            .target(.eliminated)
            .on([.anotherEliminated])
    }

    static let sidKetchum = Card(.sidKetchum, prototype: pDefault, attributes: [.maxHealth: 4]) {
        CardEffect.group {
            CardEffect.discard(.selectHand)
                .repeat(2)
            CardEffect.heal(1)
        }
        .on([.playAbility])
    }

    static let blackJack = Card(.blackJack, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
        CardEffect.group {
            CardEffect.drawDeck
                .repeat(.attr(.startTurnCards))
            CardEffect.luck(.lastHand, regex: .regexDrawAnotherCard, onSuccess: .drawDeck)
        }
        .on([.setTurn])
    }

    static let kitCarlson = Card(.kitCarlson, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
        CardEffect.group {
            CardEffect.drawDeck
                .repeat(.attr(.startTurnCards))
            CardEffect.drawDeck
//            CardEffect.putBackHand
        }
        .on([.setTurn])
    }

    static let jesseJones = Card(.jesseJones, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
        CardEffect.group {
            CardEffect.drawDiscard
                .force(otherwise: .drawDeck)
            CardEffect.drawDeck
                .repeat(.add(-1, attr: .startTurnCards))
        }
        .on([.setTurn])
    }

    static let pedroRamirez = Card(.pedroRamirez, prototype: pDefault, attributes: [.maxHealth: 4], silent: [.drawOnSetTurn]) {
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

private extension CardList {
    /// Order in which triggered effects are dispatched
    /// sorted from highest to lowest priority
    static let priorities: [String] = [
        .updateGameOverOnEliminated,
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

private func createCardDict(_ priorities: [String], @CardBuilder content: () -> [Card]) -> [String: Card] {
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
