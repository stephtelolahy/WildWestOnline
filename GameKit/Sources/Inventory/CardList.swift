//
//  CardList.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
import Game

public enum CardList {

    public static let all: [String: Card] = createCardDict {
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
        evaluateAttributesOnUpdateInPlay
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

    public static let defaultAbilities: [String] = [
        .endTurn,
        .drawOnSetTurn,
        .eliminateOnDamageLethal,
        .discardCardsOnEliminated,
        .nextTurnOnEliminated,
        .evaluateAttributesOnUpdateInPlay,
        .discardPreviousWeaponOnPlayWeapon
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

    static let schofield = Card(.schofield, attributes: [.weapon: 2], prototype: equipement)

    static let remington = Card(.remington, attributes: [.weapon: 3], prototype: equipement)

    static let revCarabine = Card(.revCarabine, attributes: [.weapon: 4], prototype: equipement)

    static let winchester = Card(.winchester, attributes: [.weapon: 5], prototype: equipement)

    static let volcanic = Card(.volcanic, attributes: [.weapon: 1, .bangsPerTurn: 0], prototype: equipement)

    static let scope = Card(.scope, attributes: [.scope: 1], prototype: equipement)

    static let mustang = Card(.mustang, attributes: [.mustang: 1], prototype: equipement)

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

    static let evaluateAttributesOnUpdateInPlay = Card(.evaluateAttributesOnUpdateInPlay) {
        CardEffect.updateAttributes
            .target(.actor)
            .on([.updateInPlay])
    }

    // MARK: - Figures

    static let figure = Card(String(), attributes: [
        .startTurnCards: 2,
        .weapon: 1,
        .flippedCards: 1,
        .bangsPerTurn: 1,
        .scope: 0,
        .mustang: 0
    ])

    static let willyTheKid = Card(.willyTheKid, attributes: [.maxHealth: 4, .bangsPerTurn: 0], prototype: figure)

    static let roseDoolan = Card(.roseDoolan, attributes: [.maxHealth: 4, .scope: 1], prototype: figure)

    static let paulRegret = Card(.paulRegret, attributes: [.maxHealth: 3, .mustang: 1], prototype: figure)

    static let jourdonnais = Card(.jourdonnais, attributes: [.maxHealth: 4], prototype: figure) {
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .counterShoot)
            .on([.shot])
    }

    static let slabTheKiller = Card(.slabTheKiller, attributes: [.maxHealth: 4], prototype: figure)

    static let luckyDuke = Card(.luckyDuke, attributes: [.maxHealth: 4, .flippedCards: 2], prototype: figure)

    static let calamityJanet = Card(.calamityJanet, attributes: [.maxHealth: 4], prototype: figure)

    static let bartCassidy = Card(.bartCassidy, attributes: [.maxHealth: 4], prototype: figure) {
        CardEffect.draw
            .target(.actor)
            .repeat(.damage)
            .on([.damage])
    }

    static let elGringo = Card(.elGringo, attributes: [.maxHealth: 3], prototype: figure) {
        CardEffect.steal(.randomHand, toPlayer: .actor)
            .target(.offender)
            .repeat(.damage)
            .on([.damage])
    }

    static let suzyLafayette = Card(.suzyLafayette, attributes: [.maxHealth: 4], prototype: figure) {
        CardEffect.draw
            .target(.actor)
            .on([.handEmpty])
    }

    static let vultureSam = Card(.vultureSam, attributes: [.maxHealth: 4], prototype: figure) {
        CardEffect.steal(.all, toPlayer: .actor)
            .target(.eliminated)
            .on([.anotherEliminated])
    }

    static let sidKetchum = Card(.sidKetchum, attributes: [.maxHealth: 4], prototype: figure) {
        CardEffect.group {
            CardEffect.discard(.selectHand)
                .target(.actor)
                .repeat(.exact(2))
            CardEffect.heal(1)
                .target(.actor)
        }
        .on([.playAbility])
    }

    static let blackJack = Card(.blackJack, attributes: [.maxHealth: 4], prototype: figure)

    static let kitCarlson = Card(.kitCarlson, attributes: [.maxHealth: 4], prototype: figure)

    static let jesseJones = Card(.jesseJones, attributes: [.maxHealth: 4], prototype: figure)

    static let pedroRamirez = Card(.pedroRamirez, attributes: [.maxHealth: 4], prototype: figure)
}

private func createCardDict(@CardBuilder _ content: () -> [Card]) -> [String: Card] {
    content().reduce(into: [String: Card]()) {
        $0[$1.name] = $1
    }
}
