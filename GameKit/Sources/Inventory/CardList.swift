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
        evaluateAttributeOnUpdateInPlay
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
            .require(.isPlayersAtLeast(3))
            .when(.onPlayImmediate)
    }

    static let saloon = Card(.saloon) {
        CardEffect.heal(1)
            .target(.damaged)
            .when(.onPlayImmediate)
    }

    static let stagecoach = Card(.stagecoach) {
        CardEffect.draw
            .target(.actor)
            .repeat(2)
            .when(.onPlayImmediate)
    }

    static let wellsFargo = Card(.wellsFargo) {
        CardEffect.draw
            .target(.actor)
            .repeat(3)
            .when(.onPlayImmediate)
    }

    static let catBalou = Card(.catBalou) {
        CardEffect.discard(.selectAny, chooser: .actor)
            .target(.selectAny)
            .when(.onPlayImmediate)
    }

    static let panic = Card(.panic) {
        CardEffect.steal(.selectAny, chooser: .actor)
            .target(.selectAt(1))
            .when(.onPlayImmediate)
    }

    static let generalStore = Card(.generalStore) {
        CardEffect.group {
            CardEffect.discover
                .repeat(.numPlayers)
            CardEffect.chooseCard
                .target(.all)
        }
        .when(.onPlayImmediate)
    }

    static let bang = Card(.bang) {
        CardEffect.shoot
            .target(.selectReachable)
            .require(.isCardPlayedLessThan(.bang, .playerAttr(.bangsPerTurn)))
            .when(.onPlayImmediate)
    }

    static let missed = Card(.missed) {
        CardEffect.activate
            .when(.onShot)
        CardEffect.cancel(.effectOfShoot)
            .when(.onPlayImmediate)
    }

    static let gatling = Card(.gatling) {
        CardEffect.shoot
            .target(.others)
            .when(.onPlayImmediate)
    }

    static let indians = Card(.indians) {
        CardEffect.discard(.selectHandNamed(.bang))
            .force(.damage(1))
            .target(.others)
            .when(.onPlayImmediate)
    }

    static let duel = Card(.duel) {
        CardEffect.discard(.selectHandNamed(.bang))
            .challenge(.actor, otherwise: .damage(1))
            .target(.selectAny)
            .when(.onPlayImmediate)
    }

    static let barrel = Card(.barrel, prototype: equipement) {
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .cancel(.effectOfShoot))
            .when(.onShot)
    }

    static let dynamite = Card(.dynamite, prototype: equipement) {
        CardEffect.luck(.regexPassDynamite,
                        onSuccess: .passInplay(.played, owner: .actor).target(.next),
                        onFailure: .group([
                            .damage(3).target(.actor),
                            .discard(.played).target(.actor)
                        ]))
        .when(.onSetTurn)
    }

    // MARK: - Collectibles - Handicap

    static let jail = Card(.jail) {
        CardEffect.nothing
            .target(.selectAny)
            .when(.onPlayHandicap)
        CardEffect.luck(.regexEscapeFromJail,
                        onSuccess: .discard(.played).target(.actor),
                        onFailure: .group([
                            .cancel(.effectOfCard(.drawOnSetTurn)),
                            .discard(.played).target(.actor),
                            .setTurn.target(.next)
                        ]))
        .when(.onSetTurn)
    }

    // MARK: - Collectibles - Equipment

    static let equipement = Card(String()) {
        CardEffect.nothing
            .when(.onPlayEquipment)
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
        .when(.onPlayAbility)
    }

    static let drawOnSetTurn = Card(.drawOnSetTurn) {
        CardEffect.draw
            .target(.actor)
            .repeat(.playerAttr(.startTurnCards))
            .when(.onSetTurn)
    }

    static let eliminateOnDamageLethal = Card(.eliminateOnDamageLethal) {
        CardEffect.eliminate
            .target(.actor)
            .when(.onDamageLethal)
    }

    static let nextTurnOnEliminated = Card(.nextTurnOnEliminated) {
        CardEffect.setTurn
            .target(.next)
            .when(.onEliminatedYourTurn)
    }

    static let discardCardsOnEliminated = Card(.discardCardsOnEliminated) {
        CardEffect.discard(.all)
            .target(.actor)
            .when(.onEliminated)
    }

    static let discardPreviousWeaponOnPlayWeapon = Card(.discardPreviousWeaponOnPlayWeapon) {
        CardEffect.discard(.previousInPlayWithAttribute(.weapon))
            .target(.actor)
            .when(.onPlayWeapon)
    }

    static let evaluateAttributeOnUpdateInPlay = Card(.evaluateAttributeOnUpdateInPlay) {
        CardEffect.evaluateAttributes
            .target(.actor)
            .when(.onUpdateInPlay)
    }

    // MARK: - Figures

    static let willyTheKid = Card(.willyTheKid, attributes: [.maxHealth: 4, .bangsPerTurn: 0])

    static let roseDoolan = Card(.roseDoolan, attributes: [.maxHealth: 4, .scope: 1])

    static let paulRegret = Card(.paulRegret, attributes: [.maxHealth: 3])

    static let jourdonnais = Card(.jourdonnais, attributes: [.maxHealth: 4])

    static let slabTheKiller = Card(.slabTheKiller, attributes: [.maxHealth: 4])

    static let luckyDuke = Card(.luckyDuke, attributes: [.maxHealth: 4])

    static let calamityJanet = Card(.calamityJanet, attributes: [.maxHealth: 4])

    static let bartCassidy = Card(.bartCassidy, attributes: [.maxHealth: 4])

    static let elGringo = Card(.elGringo, attributes: [.maxHealth: 3])

    static let suzyLafayette = Card(.suzyLafayette, attributes: [.maxHealth: 4])

    static let vultureSam = Card(.vultureSam, attributes: [.maxHealth: 4])

    static let sidKetchum = Card(.sidKetchum, attributes: [.maxHealth: 4])

    static let blackJack = Card(.blackJack, attributes: [.maxHealth: 4])

    static let kitCarlson = Card(.kitCarlson, attributes: [.maxHealth: 4])

    static let jesseJones = Card(.jesseJones, attributes: [.maxHealth: 4])

    static let pedroRamirez = Card(.pedroRamirez, attributes: [.maxHealth: 4])
}

private func createCardDict(@CardBuilder _ content: () -> [Card]) -> [String: Card] {
    content().reduce(into: [String: Card]()) {
        $0[$1.name] = $1
    }
}

private func createCardArray(@CardBuilder _ content: () -> [Card]) -> [Card] {
    content()
}
