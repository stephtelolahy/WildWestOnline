import Foundation

// MARK: - Card definition

struct Card {
    var onPlay: Effect?
    var canPlay: Requirement?
    var onActive: Effect?
    var onShot: Effect?
    var onTurnStarted: Effect?
    var onDamaged: Effect?
    var onHandEmptied: Effect?
    var onOtherEliminated: Effect?
    var onDrawRequired: Effect?
    var onDrawLastCardOnTurnStarted: Effect?
    var onShootingWithBangCard: Effect?
}

struct CardEffect {
    let trigger: GameEvent
    let action: Effect
}

typealias CardDefinition = [CardEffect]

enum GameEvent {
    case cardPlayed
    case cardEquipped
    case playerShot
    case turnStarted

    case playerDamaged(target: PlayerID, source: PlayerID)
    case playerEliminated(target: PlayerID, source: PlayerID)
}

enum PlayerID {}
enum CardID {}

indirect enum Effect {
    // MARK: - Logic
    case `repeat`(Repeat, Self)
    case concat([Self]) // independent effects
    case chain([Self])
    case draw(String, then: Self, else: Self? = nil)
    case askForCounter(String, Self)
    case askForRedirect(String, Self)
    case askForCost(Int, Self)
    case require(Requirement, Self)

    // MARK: - Action
    case drawDeck(PlayerRef)
    case heal(Int, PlayerRef)
    case discard(PlayerRef, CardRef)
    case steal(PlayerRef, CardRef, PlayerRef)
    case discover
    case undiscover
    case drawDiscovered(CardRef, PlayerRef)
    case drawDiscared(CardRef, PlayerRef)
    case shoot(PlayerRef)
    case dodge(PlayerRef)
    case damage(Int, PlayerRef)
    case passLeft(CardRef)
    case endTurn
    case showLastHand(PlayerRef)

    // MARK: - Modifier
    case setWeaponRange(Int)
    case ignorePlayLimit(String)
    case incrementMagnifying
    case incrementRemoteness
    case incrementDrawCards
    case setCardsPerTurn(Int)
    case incrementRequiredMisses
    case playAs(String, String)
    case nothing
}

enum PlayerRef {
    case me
    case eliminated
    case i
    case attacker
    case chooseAny
    case chooseAnyAtWeaponRange
    case chooseAnyWithCard
    case chooseAnyWithCardAtRange(Int)
    case chooseAnyWithHandCard
}

enum CardRef {
    case sourceCard
    case i
    case chooseAnyTargetCard
    case chooseAnyTargetHandCard
    case chooseAnyDiscoveredCard
    case chooseDiscardedCard
}

enum Repeat {
    case times(Int)
    case perPlayerWounded
    case perPlayerActive
    case perPlayerOther
    case perDamage
    case perCardOfEliminatedPlayer
}

enum Requirement {
    case playersAtLeast(Int)
    case playLimit(Int)
}

// MARK: - Cards

extension CardDefinition {
    static var stagecoach: Self {
        [
            .init(
                trigger: .cardPlayed,
                action: .repeat(.times(2), .drawDeck(.me))
            )
        ]
    }
/*
    static var wellsFargo: Self {
        .init(
            trigger: .cardPlayed,
            action: .repeat(.times(3), .drawDeck(.me))
        )
    }

    static var beer: Self {
        .init(
            trigger: .cardPlayed,
            action: .require(.playersAtLeast(3), .heal(1, .me))
        )
    }

    static var saloon: Self {
        .init(
            trigger: .cardPlayed,
            action: .repeat(.perPlayerWounded, .heal(1, .i))
        )
    }

    static var catBalou: Self {
        .init(
            trigger: .cardPlayed,
            action: .discard(.chooseAnyWithCard, .chooseAnyTargetCard)
        )
    }

    static var panic: Self {
        .init(
            trigger: .cardPlayed,
            action: .steal(.chooseAnyWithCardAtRange(1), .chooseAnyTargetCard, .me)
        )
    }

    static var generalStore: Self {
        .init(
            trigger: .cardPlayed,
            action: .concat([
                .repeat(.perPlayerActive, .discover),
                .repeat(.perPlayerActive, .drawDiscovered(.chooseAnyDiscoveredCard, .i))
            ])
        )
    }

    static var bang: Self {
        .init(
            trigger: .cardPlayed,
            action: .require(.playLimit(1), .shoot(.chooseAnyAtWeaponRange))
        )
    }

    static var missed: Self {
        .init(
            trigger: .cardPlayed,
            action: .dodge(.me)
        )
    }

    static var gatling: Self {
        .init(
            trigger: .cardPlayed,
            action: .repeat(.perPlayerOther, .shoot(.i))
        )
    }

    static var indians: Self {
        .init(
            trigger: .cardPlayed,
            action: .repeat(.perPlayerOther, .askForCounter("bang", .damage(1, .i)))
        )
    }

    static var duel: Self {
        .init(
            trigger: .cardPlayed,
            action: .askForRedirect("bang", .damage(1, .chooseAny))
        )
    }

    static var schofield: Self {
        .init(
            trigger: .cardEquipped,
            action: .setWeaponRange(2)
        )
    }

    static var remington: Self {
        .init(
            trigger: .cardEquipped,
            action: .setWeaponRange(3)
        )
    }

    static var revCarabine: Self {
        .init(
            trigger: .cardEquipped,
            action: .setWeaponRange(4)
        )
    }

    static var winchester: Self {
        .init(
            trigger: .cardEquipped,
            action: .setWeaponRange(5)
        )
    }

    static var volcanic: Self {
        .init(
            trigger: .cardEquipped,
            action: .concat([
                .setWeaponRange(1),
                .ignorePlayLimit("bang")
            ])
        )
    }

    static var scope: Self {
        .init(
            trigger: .cardEquipped,
            action: .incrementMagnifying
        )
    }

    static var mustang: Self {
        .init(
            trigger: .cardEquipped,
            action: .incrementRemoteness
        )
    }
*/
    static var barrel: Self {
        [
            .init(
                trigger: .cardEquipped,
                action: .nothing
            ),
            .init(
                trigger: .playerShot,
                action: .draw("♥️", then: .dodge(.me))
            )
        ]
    }

    static var dynamite: Self {
        [
            .init(
                trigger: .cardEquipped,
                action: .nothing
            ),
            .init(
                trigger: .turnStarted,
                action: .draw(
                    "([2|3|4|5|6|7|8|9]♠️)",
                    then: .concat([
                        .damage(3, .me),
                        .discard(.me, .sourceCard)
                    ]) ,
                    else: .passLeft(.sourceCard)
                )
            )
        ]
    }

        /*
    static var jail: Self {
        onTurnStarted: .concat([
            .draw(
                "not(♥️)",
                then: .endTurn
            ),
            .discard(.me, .sourceCard)
        ])
    )

    static var willyTheKid: Self {
        onActive: .ignorePlayLimit("bang")
    )

    static var roseDoolan: Self {
        onActive: .incrementMagnifying
    )

    static var paulRegret: Self {
        onActive: .incrementRemoteness
    )

    static var bartCassidy: Self {
        onDamaged: .repeat(.perDamage, .drawDeck(.me))
    )

    static var elGringo: Self {
        onDamaged: .repeat(.perDamage, .steal(.attacker, .chooseAnyTargetCard, .me))
    )

    static var suzyLafayette: Self {
        onHandEmptied: .drawDeck(.me)
    )

    static var jourdonnais: Self {
        onShot: .draw("♥️", then: .dodge(.me))
    )

    static var sidKetchum: Self {
        onActive: .askForCost(2, .heal(1, .me))
    )

    static var vultureSam: Self {
        onOtherEliminated: .repeat(.perCardOfEliminatedPlayer, .steal(.eliminated, .i, .me))
    )

    static var luckyDuke: Self {
        onDrawRequired: .incrementDrawCards
    )

    static var blackJack: Self {
        onDrawLastCardOnTurnStarted: .concat([
            .showLastHand(.me),
            .draw("(♥️)|(♦️)", then: .drawDeck(.me))
        ])
    )

    static var pedroRamirez: Self {
        onTurnStarted: .chain([
            .steal(.chooseAnyWithHandCard, .chooseAnyTargetHandCard, .me),
            .setCardsPerTurn(1)
        ])
    )

    static var jesseJones: Self {
        onTurnStarted: .chain([
            .drawDiscared(.chooseDiscardedCard, .me),
            .setCardsPerTurn(1)
        ])
    )

    static var kitCarlson: Self {
        onTurnStarted: .chain([
            .repeat(.times(3), .discover),
            .repeat(.times(2), .drawDiscovered(.chooseAnyDiscoveredCard, .me)),
            .undiscover,
            .setCardsPerTurn(0)
        ])
    )

    static var slabTheKiller: Self {
        onShootingWithBangCard: .incrementRequiredMisses
    )

    static var calamityJanet: Self {
        onActive: .concat([
            .playAs("missed", "bang"),
            .playAs("bang", "missed")
        ])
    )
        */
}
