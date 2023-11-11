//
//  CardList.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
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
            .target(.actor)
            .on([.playImmediate, .isPlayersAtLeast(3)])
    }

    static let saloon = Card(.saloon) {
        CardEffect.heal(1)
            .target(.damaged)
            .on([.playImmediate])
    }

    static let stagecoach = Card(.stagecoach) {
        CardEffect.draw
            .target(.actor)
            .repeat(2)
            .on([.playImmediate])
    }

    static let wellsFargo = Card(.wellsFargo) {
        CardEffect.draw
            .target(.actor)
            .repeat(3)
            .on([.playImmediate])
    }

    static let catBalou = Card(.catBalou) {
        CardEffect.discard(.selectAny, chooser: .actor)
            .target(.selectAny)
            .on([.playImmediate])
    }

    static let panic = Card(.panic) {
        CardEffect.steal(.selectAny, toPlayer: .actor)
            .target(.selectAt(1))
            .on([.playImmediate])
    }

    static let generalStore = Card(.generalStore) {
        CardEffect.group {
            CardEffect.discover
                .repeat(.activePlayers)
            CardEffect.chooseCard(.selectArena)
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
        CardEffect.activate
            .on([.shot])
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
        CardEffect.luck(.regexEscapeFromJail,
                        onSuccess: .discard(.played).target(.actor),
                        onFailure: .group([
                            .cancelEffectOfCard(.drawOnSetTurn),
                            .discard(.played).target(.actor),
                            .setTurn.target(.next)
                        ]))
        .on([.setTurn])
    }

    // MARK: - Collectibles - Equipment

    static let equipement = Card(String()) {
        CardEffect.nothing
            .on([.playEquipment])
    }

    static let barrel = Card(.barrel, prototype: equipement) {
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .counterShoot)
            .on([.shot])
    }

    static let dynamite = Card(.dynamite, prototype: equipement) {
        CardEffect.luck(.regexPassDynamite,
                        onSuccess: .passInplay(.played, toPlayer: .next).target(.actor),
                        onFailure: .group([
                            .damage(3).target(.actor),
                            .discard(.played).target(.actor)
                        ]))
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
                .target(.actor)
                .repeat(.excessHand)
            CardEffect.setTurn
                .target(.next)
        }
        .on([.playAbility])
    }

    static let drawOnSetTurn = Card(.drawOnSetTurn) {
        CardEffect.draw
            .target(.actor)
            .repeat(.attr(.startTurnCards))
            .on([.setTurn])
    }

    static let eliminateOnDamageLethal = Card(.eliminateOnDamageLethal) {
        CardEffect.eliminate
            .target(.actor)
            .on([.damageLethal])
    }

    static let nextTurnOnEliminated = Card(.nextTurnOnEliminated) {
        CardEffect.setTurn
            .target(.next)
            .on([.eliminated, .isYourTurn])
    }

    static let discardCardsOnEliminated = Card(.discardCardsOnEliminated) {
        CardEffect.discard(.all)
            .target(.actor)
            .on([.eliminated])
    }

    static let discardPreviousWeaponOnPlayWeapon = Card(.discardPreviousWeaponOnPlayWeapon) {
        CardEffect.discard(.previousInPlayWithAttribute(.weapon))
            .target(.actor)
            .on([.playWeapon])
    }

    static let updateAttributesOnChangeInPlay = Card(.updateAttributesOnChangeInPlay) {
        CardEffect.updateAttributes
            .target(.actor)
            .on([.changeInPlay])
    }

    // MARK: - Figures

    static let figure = Card(String(), attributes: [
        .startTurnCards: 2,
        .weapon: 1,
        .flippedCards: 1,
        .bangsPerTurn: 1,
        .endTurn: 0,
        .drawOnSetTurn: 0,
        .eliminateOnDamageLethal: 0,
        .discardCardsOnEliminated: 0,
        .nextTurnOnEliminated: 0,
        .updateAttributesOnChangeInPlay: 0,
        .discardPreviousWeaponOnPlayWeapon: 0
    ])

    static let willyTheKid = Card(.willyTheKid, prototype: figure, attributes: [.maxHealth: 4, .bangsPerTurn: 0])

    static let roseDoolan = Card(.roseDoolan, prototype: figure, attributes: [.maxHealth: 4, .scope: 1])

    static let paulRegret = Card(.paulRegret, prototype: figure, attributes: [.maxHealth: 3, .mustang: 1])

    static let jourdonnais = Card(.jourdonnais, prototype: figure, attributes: [.maxHealth: 4]) {
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .counterShoot)
            .on([.shot])
    }

    static let slabTheKiller = Card(.slabTheKiller, prototype: figure, attributes: [.maxHealth: 4])

    static let luckyDuke = Card(.luckyDuke, prototype: figure, attributes: [.maxHealth: 4, .flippedCards: 2])

    static let calamityJanet = Card(.calamityJanet, prototype: figure, attributes: [.maxHealth: 4])

    static let bartCassidy = Card(.bartCassidy, prototype: figure, attributes: [.maxHealth: 4]) {
        CardEffect.draw
            .target(.actor)
            .repeat(.damage)
            .on([.damage])
    }

    static let elGringo = Card(.elGringo, prototype: figure, attributes: [.maxHealth: 3]) {
        CardEffect.steal(.randomHand, toPlayer: .actor)
            .target(.offender)
            .repeat(.damage)
            .on([.damage])
    }

    static let suzyLafayette = Card(.suzyLafayette, prototype: figure, attributes: [.maxHealth: 4]) {
        CardEffect.draw
            .target(.actor)
            .on([.handEmpty])
    }

    static let vultureSam = Card(.vultureSam, prototype: figure, attributes: [.maxHealth: 4]) {
        CardEffect.steal(.all, toPlayer: .actor)
            .target(.eliminated)
            .on([.anotherEliminated])
    }

    static let sidKetchum = Card(.sidKetchum, prototype: figure, attributes: [.maxHealth: 4]) {
        CardEffect.group {
            CardEffect.discard(.selectHand)
                .target(.actor)
                .repeat(.exact(2))
            CardEffect.heal(1)
                .target(.actor)
        }
        .on([.playAbility])
    }

    static let blackJack = Card(.blackJack, prototype: figure, silent: [.drawOnSetTurn], attributes: [.maxHealth: 4]) {
        CardEffect.group {
            CardEffect.draw
                .target(.actor)
                .repeat(.attr(.startTurnCards))
            CardEffect.revealLastDrawn(.regexDrawAnotherCard, onSuccess: .draw.target(.actor))
        }
        .on([.setTurn])
    }

    static let kitCarlson = Card(.kitCarlson, prototype: figure, attributes: [.maxHealth: 4])

    static let jesseJones = Card(.jesseJones, prototype: figure, attributes: [.maxHealth: 4])

    static let pedroRamirez = Card(.pedroRamirez, prototype: figure, attributes: [.maxHealth: 4])
}

private extension CardList {
    /// Order in which triggered effects are queued
    /// sorted from highest to lowest priority
    static let priorities: [String] = [
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
