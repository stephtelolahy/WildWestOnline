import Foundation

// MARK: - Card definition

struct CardDefinition {
    let tag: CardTag
    let trigger: GameEvent
    let actions: [GameAction] // Flat Actions model
}

enum CardTag: String {
    case brown
    case equipement
    case handcap
}

struct GameAction {
    let id: GameActionID
    var selector: [Selector] = []
}

enum GameActionID: String {
    // MARK: - Visible Action
    case drawDeck
    case dodge
    case draw
    case damage
    case discard
    case passLeft
    case heal
}

enum Selector {
    // MARK: - Logic
    case `if`(Requirement)
    case require(Requirement)
    case `repeat`(Repeat)

    // MARK: - Payload
    case setTarget(PlayerRef)
    case setCard(CardRef)
    case setAmount(Int)
}

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

@available(*, deprecated, message: "Use GameAction instead")
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
    case perTarget(TargetGroup)
    case perPlayerActive
    case perPlayerOther
    case perDamage
    case perCardOfEliminatedPlayer
}

enum TargetGroup {
    case woundedPlayers
}

indirect enum Requirement {
    case not(Self)
    case drawMatched(CardSuit)
    case playersAtLeast(Int)
    case playLimit(Int)
}

enum CardSuit: String {
    case hearts = "♥️"
    case red = "(♥️)|(♦️)"
    case twoToNineSpades = "([2|3|4|5|6|7|8|9]♠️)"
}

// MARK: - Cards

extension CardDefinition {
    static var stagecoach: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .drawDeck,
                    selector: [
                        .setTarget(.me),
                        .repeat(.times(2))
                    ]
                )
            ]
        )
    }

    static var wellsFargo: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .drawDeck,
                    selector: [
                        .setTarget(.me),
                        .repeat(.times(3))
                    ]
                )
            ]
        )
    }

    static var beer: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .heal,
                    selector: [
                        .require(.playersAtLeast(3)),
                        .setTarget(.me),
                        .setAmount(1)
                    ]
                )
            ]
        )
    }

    static var saloon: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .heal,
                    selector: [
                        .setAmount(1),
                        .repeat(.perTarget(.woundedPlayers)),
                    ]
                )
            ]
        )
    }
    /*
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
        .init(
            tag: .equipement,
            trigger: .playerShot,
            actions: [
                .init(id: .draw),
                .init(
                    id: .dodge,
                    selector: [
                        .if(.drawMatched(.hearts)),
                        .setTarget(.me)
                    ]
                )
            ]
        )
    }

    static var dynamite: Self {
        .init(
            tag: .equipement,
            trigger: .turnStarted,
            actions: [
                .init(id: .draw),
                .init(
                    id: .damage,
                    selector: [
                        .if(.drawMatched(.twoToNineSpades)),
                        .setTarget(.me),
                        .setAmount(3)
                    ]
                ),
                .init(
                    id: .discard,
                    selector: [
                        .if(.drawMatched(.twoToNineSpades)),
                        .setCard(.sourceCard)
                    ]
                ),
                .init(
                    id: .passLeft,
                    selector: [
                        .if(.not(.drawMatched(.twoToNineSpades))),
                        .setCard(.sourceCard)
                    ]
                )
            ]
        )
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
