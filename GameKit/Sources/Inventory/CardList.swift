//
//  CardList.swift
//
//
//  Created by Hugues Telolahy on 12/04/2023.
//
import Game

public enum CardList {
    public static let all: [String: Card] = createCardRef {
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
        eliminateOnLooseLastHealth
        nextTurnOnEliminated
        discardCardsOnEliminated
        evaluateGameOverOnEliminated
        discardPreviousWeaponOnPlayWeapon
        evaluateActiveCardsOnIdle
    }
}

private extension CardList {
    
    // MARK: - Collectibles
    
    static let beer = Card(.beer) {
        CardEffect.heal(1)
            .target(.actor)
            .when(.onPlayImmediate, .isPlayersAtLeast(3))
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
        CardEffect.discard(.selectHandNamed(.missed))
            .otherwise(.damage(1))
            .target(.selectReachable)
            .when(.onPlayImmediate, .isTimesPerTurn(.playerAttr(.bangsPerTurn)))
    }
    
    static let missed = Card(.missed)
    
    static let gatling = Card(.gatling) {
        CardEffect.discard(.selectHandNamed(.missed))
            .otherwise(.damage(1))
            .target(.others)
            .when(.onPlayImmediate)
    }
    
    static let indians = Card(.indians) {
        CardEffect.discard(.selectHandNamed(.bang))
            .otherwise(.damage(1))
            .target(.others)
            .when(.onPlayImmediate)
    }
    
    static let duel = Card(.duel) {
        CardEffect.discard(.selectHandNamed(.bang))
            .challenge(.actor, otherwise: .damage(1))
            .target(.selectAny)
            .when(.onPlayImmediate)
    }
    
    static let barrel = Card(.barrel) {
        CardEffect.nothing
            .when(.onPlayEquipment)
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .cancel(.next))
            .when(.onForceDiscardHandNamed(.missed))
    }
    
    static let dynamite = Card(.dynamite) {
        CardEffect.nothing
            .when(.onPlayEquipment)
        CardEffect.luck(.regexPassDynamite,
                        onSuccess: .passInplay(.played, owner: .actor).target(.next),
                        onFailure: .group([
                            .damage(3).target(.actor),
                            .discard(.played).target(.actor)
                        ]))
        .when(.onSetTurn)
    }
    
    // MARK: - Handicap
    
    static let jail = Card(.jail) {
        CardEffect.nothing
            .target(.selectAny)
            .when(.onPlayHandicap)
        CardEffect.luck(.regexEscapeFromJail,
                        onSuccess: .discard(.played).target(.actor),
                        onFailure: .group([
                            .cancel(.effectOfCardNamed(.drawOnSetTurn)),
                            .discard(.played).target(.actor),
                            .setTurn.target(.next)
                        ]))
        .when(.onSetTurn)
    }
    
    // MARK: - Equipement
    
    static let equipement = Card(String()) {
        CardEffect.evaluateAttributes
            .target(.actor)
            .when(.onPlayEquipment)
        CardEffect.evaluateAttributes
            .target(.actor)
            .when(.onDiscardedFromPlay)
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
    
    static let eliminateOnLooseLastHealth = Card(.eliminateOnLooseLastHealth) {
        CardEffect.eliminate
            .target(.actor)
            .when(.onLooseLastHealth)
    }
    
    static let nextTurnOnEliminated = Card(.nextTurnOnEliminated) {
        CardEffect.setTurn
            .target(.next)
            .when(.onEliminated, .isYourTurn)
    }
    
    static let discardCardsOnEliminated = Card(.discardCardsOnEliminated) {
        CardEffect.discard(.all)
            .target(.actor)
            .when(.onEliminated)
    }
    
    static let evaluateGameOverOnEliminated = Card(.evaluateGameOverOnEliminated) {
        CardEffect.evaluateGameOver
            .when(.onEliminated)
    }

    static let discardPreviousWeaponOnPlayWeapon = Card(.discardPreviousWeaponOnPlayWeapon) {
        CardEffect.discard(.previousInPlayWithAttribute(.weapon))
            .target(.actor)
            .when(.onPlayEquipmentWithAttribute(.weapon))
    }

    static let evaluateActiveCardsOnIdle = Card(.evaluateActiveCardsOnIdle) {
        CardEffect.evaluateActiveCards
            .target(.actor)
            .when(.onIdle)
    }

    static func createCardRef(@CardBuilder _ content: () -> [Card]) -> [String: Card] {
        content().reduce(into: [String: Card]()) {
            $0[$1.name] = $1
        }
    }
}
