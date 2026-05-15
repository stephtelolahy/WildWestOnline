import Foundation

// MARK: - Card definition

struct CardDefinition {
    let tag: CardTag
    let trigger: GameEvent
    let actions: [GameAction] // Flat Actions = independent effects
}

enum CardTag: String {
    case brown
    case equipement
    case handicap
    case character
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
    case steal
    case passLeft
    case shoot
    case heal
    case endTurn
    case discover
    case undiscover
    case drawDiscovered
    case drawDiscared

    // MARK: - Modifiers
    case incrementRequiredMisses
    case incrementMagnifying
    case incrementRemoteness
    case incrementDrawCards
    case setPlayAs
    case setCardsPerTurn
    case setWeaponRange
    case ignorePlayLimit
}

enum Selector {
    // MARK: - Branching
    case `repeat`(Repeat)
    case `if`(Requirement)
    case require(Requirement)

    // MARK: - Payload
    case withTarget(PlayerRef)
    case withCard(CardRef)
    case withAmount(Int)
    case withAlias([String: String])
    case withPlayLimitCard(String)
}

enum GameEvent: String {
    case active
    case cardPlayed
    case cardEquipped
    case playerShot
    case turnStarted
    case shootingWithBangCard
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
    case attacker

    case chooseAny
    case chooseAnyAtWeaponRange
    case chooseAnyWithCard
    case chooseAnyWithCardAtRange(Int)
    case chooseAnyWithHandCard

    case forEachPlayers
    case forEachWoundedPlayers
}

enum CardRef {
    case source

    case chooseAnyTargetCard
    case chooseAnyTargetHandCard
    case chooseAnyDiscoveredCard
    case chooseDiscardedCard
}

enum Repeat {
    case times(Int)
    case perPlayer
    case perDamage
}

indirect enum Requirement {
    case not(Self)
    case drawMatched(CardSuit)
    case playersAtLeast(Int)
    case playLimit(Int)
    case hasDrawDiscardOnTurnStarted
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
                        .withTarget(.me),
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
                        .withTarget(.me),
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
                        .withTarget(.me),
                        .withAmount(1)
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
                        .withAmount(1),
                        .withTarget(.forEachWoundedPlayers)
                    ]
                )
            ]
        )
    }

    static var catBalou: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .discard,
                    selector: [
                        .withTarget(.chooseAnyWithCard),
                        .withCard(.chooseAnyTargetCard)
                    ]
                )
            ]
        )
    }

    static var panic: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .withTarget(.chooseAnyWithCardAtRange(1)),
                        .withCard(.chooseAnyTargetCard)
                    ]
                )
            ]
        )
    }

    static var generalStore: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .discover,
                    selector: [
                        .repeat(.perPlayer)
                    ]
                ),
                .init(
                    id: .drawDiscovered,
                    selector: [
                        .withTarget(.forEachPlayers),
                        .withCard(.chooseAnyDiscoveredCard)
                    ]
                )
            ]
        )
    }

    static var bang: Self {
        .init(
            tag: .brown,
            trigger: .cardPlayed,
            actions: [
                .init(
                    id: .shoot,
                    selector: [
                        .require(.playLimit(1)),
                        .withTarget(.chooseAnyAtWeaponRange)
                    ]
                )
            ]
        )
    }
    /*
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
*/
    static var schofield: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(2)])
            ]
        )
    }

    static var remington: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(3)])
            ]
        )
    }

    static var revCarabine: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(4)])
            ]
        )
    }

    static var winchester: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(5)])
            ]
        )
    }

    static var volcanic: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(
                    id: .setWeaponRange,
                    selector: [.withAmount(1)]
                ),
                .init(
                    id: .ignorePlayLimit,
                    selector: [.withPlayLimitCard("bang")]
                )
            ]
        )
    }

    static var scope: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .incrementMagnifying)
            ]
        )
    }

    static var mustang: Self {
        .init(
            tag: .equipement,
            trigger: .cardEquipped,
            actions: [
                .init(id: .incrementRemoteness)
            ]
        )
    }

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
                        .withTarget(.me)
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
                        .withTarget(.me),
                        .withAmount(3)
                    ]
                ),
                .init(
                    id: .discard,
                    selector: [
                        .if(.drawMatched(.twoToNineSpades)),
                        .withCard(.source)
                    ]
                ),
                .init(
                    id: .passLeft,
                    selector: [
                        .if(.not(.drawMatched(.twoToNineSpades))),
                        .withCard(.source)
                    ]
                )
            ]
        )
    }

    static var jail: Self {
        .init(
            tag: .handicap,
            trigger: .turnStarted,
            actions: [
                .init(id: .draw),
                .init(
                    id: .endTurn,
                    selector: [
                        .if(.drawMatched(.hearts))
                    ]
                ),
                .init(
                    id: .discard,
                    selector: [
                        .withCard(.source)
                    ]
                )
            ]
        )
    }

        /*
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
         */
    static var jesseJones: Self {
        .init(
            tag: .character,
            trigger: .turnStarted,
            actions: [
                .init(
                    id: .drawDiscared,
                    selector: [
                        .withTarget(.me),
                        .withCard(.chooseDiscardedCard)
                    ]
                ),
                .init(
                    id: .setCardsPerTurn,
                    selector: [
                        .if(.hasDrawDiscardOnTurnStarted),
                        .withAmount(1)
                    ]
                )
            ]
        )
    }

    static var kitCarlson: Self {
        .init(
            tag: .character,
            trigger: .turnStarted,
            actions: [
                .init(
                    id: .discover,
                    selector: [
                        .repeat(.times(3))
                    ]
                ),
                .init(
                    id: .drawDiscovered,
                    selector: [
                        .withTarget(.me),
                        .repeat(.times(2)),
                        .withCard(.chooseAnyDiscoveredCard)
                    ]
                ),
                .init(id: .undiscover),
                .init(
                    id: .setCardsPerTurn,
                    selector: [
                        .withAmount(0)
                    ]
                )
            ]
        )
    }

    static var slabTheKiller: Self {
        .init(
            tag: .character,
            trigger: .shootingWithBangCard,
            actions: [
                .init(id: .incrementRequiredMisses)
            ]
        )
    }

    static var calamityJanet: Self {
        .init(
            tag: .character,
            trigger: .active,
            actions: [
                .init(id: .setPlayAs, selector: [
                    .withAlias(["missed": "bang", "bang": "missed"])
                ])
            ]
        )
    }
}
