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
        endTurn
        drawOnSetTurn
        eliminateOnLooseLastHealth
        nextTurnOnEliminated
        discardCardsOnEliminated
        gameOverOnEliminated
    }
}

private extension CardList {

    // MARK: - Collectibles

    static let beer = Card(.beer) {
        CardEffect.heal(1)
            .target(.actor)
            .require(.isPlayersAtLeast(3))
            .triggered(.onPlay(.immediate))
    }

    static let saloon = Card(.saloon) {
        CardEffect.heal(1)
            .target(.damaged)
            .triggered(.onPlay(.immediate))
    }

    static let stagecoach = Card(.stagecoach) {
        CardEffect.draw
            .target(.actor)
            .repeat(2)
            .triggered(.onPlay(.immediate))
    }

    static let wellsFargo = Card(.wellsFargo) {
        CardEffect.draw
            .target(.actor)
            .repeat(3)
            .triggered(.onPlay(.immediate))
    }

    static let catBalou = Card(.catBalou) {
        CardEffect.discard(.selectAny, chooser: .actor)
            .target(.selectAny)
            .triggered(.onPlay(.immediate))
    }

    static let panic = Card(.panic) {
        CardEffect.steal(.selectAny, chooser: .actor)
            .target(.selectAt(1))
            .triggered(.onPlay(.immediate))
    }

    static let generalStore = Card(.generalStore) {
        CardEffect.group {
            CardEffect.discover
                .repeat(.numPlayers)
            CardEffect.chooseCard
                .target(.all)
        }
        .triggered(.onPlay(.immediate))
    }

    static let bang = Card(.bang) {
        CardEffect.discard(.selectHandNamed(.missed))
            .otherwise(.damage(1))
            .target(.selectReachable)
            .require(.isTimesPerTurn(1))
            .triggered(.onPlay(.immediate))
    }

    static let missed = Card(.missed)

    static let gatling = Card(.gatling) {
        CardEffect.discard(.selectHandNamed(.missed))
            .otherwise(.damage(1))
            .target(.others)
            .triggered(.onPlay(.immediate))
    }

    static let indians = Card(.indians) {
        CardEffect.discard(.selectHandNamed(.bang))
            .otherwise(.damage(1))
            .target(.others)
            .triggered(.onPlay(.immediate))
    }

    static let duel = Card(.duel) {
        CardEffect.discard(.selectHandNamed(.bang))
            .challenge(.actor, otherwise: .damage(1))
            .target(.selectAny)
            .triggered(.onPlay(.immediate))
    }

    static let barrel = Card(.barrel) {
        CardEffect.nothing
            .triggered(.onPlay(.equipment))
        CardEffect.luck(.regexSaveByBarrel, onSuccess: .cancel(.next))
            .triggered(.onForceDiscardHandNamed(.missed))
    }

    static let dynamite = Card(.dynamite) {
        CardEffect.nothing
            .triggered(.onPlay(.equipment))
        CardEffect.luck(.regexPassDynamite,
                        onSuccess: .passInplay(.played, owner: .actor).target(.next),
                        onFailure: .group([
                            .damage(3).target(.actor),
                            .discard(.played).target(.actor)
                        ]))
        .triggered(.onSetTurn)
    }

    static let jail = Card(.jail) {
        CardEffect.nothing
            .target(.selectAny)
            .triggered(.onPlay(.handicap))
        CardEffect.luck(.regexEscapeFromJail,
                        onSuccess: .discard(.played).target(.actor),
                        onFailure: .group([
                            .cancel(.effectOfCardNamed(.drawOnSetTurn)),
                            .discard(.played).target(.actor),
                            .setTurn.target(.next)
                        ]))
        .triggered(.onSetTurn)
    }

    static let schofield = Card(.schofield) {
        CardEffect.setAttribute(.weapon, value: 2)
            .target(.actor)
            .triggered(.onPlay(.equipment))
        CardEffect.resetAttribute(.weapon)
            .target(.actor)
            .triggered(.onDiscardedInPlay)
    }

    static let remington = Card(.remington) {
        CardEffect.setAttribute(.weapon, value: 3)
            .target(.actor)
            .triggered(.onPlay(.equipment))
        CardEffect.resetAttribute(.weapon)
            .target(.actor)
            .triggered(.onDiscardedInPlay)
    }

    // MARK: - Abilities

    static let endTurn = Card(.endTurn) {
        CardEffect.group {
            CardEffect.discard(.selectHand)
                .target(.actor)
                .repeat(.excessHand)
            CardEffect.setTurn
                .target(.next)
        }
        .triggered(.onPlay(.ability))
    }

    static let drawOnSetTurn = Card(.drawOnSetTurn) {
        CardEffect.draw
            .target(.actor)
            .repeat(.playerAttr(.startTurnCards))
            .triggered(.onSetTurn)
    }

    static let eliminateOnLooseLastHealth = Card(.eliminateOnLooseLastHealth) {
        CardEffect.eliminate
            .target(.actor)
            .triggered(.onLooseLastHealth)
    }

    static let nextTurnOnEliminated = Card(.nextTurnOnEliminated) {
        CardEffect.setTurn
            .target(.next)
            .require(.isYourTurn)
            .triggered(.onEliminated)
    }

    static let discardCardsOnEliminated = Card(.discardCardsOnEliminated) {
        CardEffect.discard(.all)
            .target(.actor)
            .triggered(.onEliminated)
    }

    static let gameOverOnEliminated = Card(.gameOverOnEliminated) {
        CardEffect.evaluateGameOver
            .triggered(.onEliminated)
    }

    static func createCardRef(@CardBuilder _ content: () -> [Card]) -> [String: Card] {
        content().toDictionary()
    }
}

private extension Array where Element == Card {
    func toDictionary() -> [String: Card] {
        reduce(into: [String: Card]()) {
            $0[$1.name] = $1
        }
    }
}
