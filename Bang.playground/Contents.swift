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

enum GameEvent: String {
    case active
    case played
    case shot
    case turnStarted
    case shootingWithBangCard
    case damaged
    case handEmptied
    case otherEliminated
    case drawLastCardOnTurnStarted
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
    case showLastHand

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
    case `repeat`(RepeatCount)
    case `if`(Requirement)
    case require(Requirement)
    case askForCounter(HandCardCriteria) // discard hand to counter effect
    case askForRedirect(HandCardCriteria) // discard hand to redirect effect
    case askForCost(HandCardCriteria) // discard hand to apply effect

    // MARK: - Payload
    case withTarget(PlayerRef)
    case withCard(CardRef)
    case withAmount(Int)
    case withAlias([String: String])
    case withPlayLimitCard(String)

    enum RepeatCount {
        case times(Int)
        case perPlayer
        case perDamage
    }

    enum PlayerRef {
        case me
        case eliminated
        case attacker
        case chooseAny([PlayerFilter])
        case forEach(PlayerGroup)
    }

    enum PlayerFilter {
        case hasCards
        case hasHandCards
        case atDistance(Int)
        case atWeaponRange
        case isWounded
    }

    enum PlayerGroup {
        case all
        case wounded
        case others
    }

    enum CardRef {
        case source
        case chooseAny(CardFilter)
        case forEach(CardGroup)
    }

    enum CardFilter {
        case targetCard
        case targetHandCard
        case discoveredCard
        case discardedCard
    }

    enum CardGroup {
        case targetCards
    }

    indirect enum Requirement {
        case not(Self)

        case drawMatched(CardSuit)
        case lastHandMatched(CardSuit)
        case playersAtLeast(Int)
        case playLimit(Int)
        case hasDrawDiscardOnTurnStarted
        case hasStealCardOnTurnStarted
    }

    enum CardSuit: String {
        case hearts = "♥️"
        case red = "(♥️)|(♦️)"
        case twoToNineSpades = "([2|3|4|5|6|7|8|9]♠️)"
    }

    enum HandCardCriteria: String {
        case any
        case blue
        case bang
    }
}

// MARK: - Cards

extension CardDefinition {
    static var stagecoach: Self {
        .init(
            tag: .brown,
            trigger: .played,
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
            trigger: .played,
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
            trigger: .played,
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
            trigger: .played,
            actions: [
                .init(
                    id: .heal,
                    selector: [
                        .withAmount(1),
                        .withTarget(.forEach(.wounded))
                    ]
                )
            ]
        )
    }

    static var catBalou: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .discard,
                    selector: [
                        .withTarget(.chooseAny([.hasCards])),
                        .withCard(.chooseAny(.targetCard))
                    ]
                )
            ]
        )
    }

    static var panic: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .withTarget(.chooseAny([.atDistance(1), .hasCards])),
                        .withCard(.chooseAny(.targetCard))
                    ]
                )
            ]
        )
    }

    static var generalStore: Self {
        .init(
            tag: .brown,
            trigger: .played,
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
                        .withTarget(.forEach(.all)),
                        .withCard(.chooseAny(.discoveredCard))
                    ]
                )
            ]
        )
    }

    static var bang: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .shoot,
                    selector: [
                        .require(.playLimit(1)),
                        .withTarget(.chooseAny([.atWeaponRange]))
                    ]
                )
            ]
        )
    }

    static var missed: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .dodge,
                    selector: [.withTarget(.me)]
                )
            ]
        )
    }

    static var gatling: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .shoot,
                    selector: [
                        .withTarget(.forEach(.others))
                    ]
                )
            ]
        )
    }

    static var indians: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .damage,
                    selector: [
                        .withAmount(1),
                        .withTarget(.forEach(.others)),
                        .askForCounter(.bang)
                    ]
                )
            ]
        )
    }

    static var duel: Self {
        .init(
            tag: .brown,
            trigger: .played,
            actions: [
                .init(
                    id: .damage,
                    selector: [
                        .withAmount(1),
                        .withTarget(.chooseAny([])),
                        .askForRedirect(.bang)
                    ]
                )
            ]
        )
    }

    static var schofield: Self {
        .init(
            tag: .equipement,
            trigger: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(2)])
            ]
        )
    }

    static var remington: Self {
        .init(
            tag: .equipement,
            trigger: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(3)])
            ]
        )
    }

    static var revCarabine: Self {
        .init(
            tag: .equipement,
            trigger: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(4)])
            ]
        )
    }

    static var winchester: Self {
        .init(
            tag: .equipement,
            trigger: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.withAmount(5)])
            ]
        )
    }

    static var volcanic: Self {
        .init(
            tag: .equipement,
            trigger: .active,
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
            trigger: .active,
            actions: [
                .init(id: .incrementMagnifying)
            ]
        )
    }

    static var mustang: Self {
        .init(
            tag: .equipement,
            trigger: .active,
            actions: [
                .init(id: .incrementRemoteness)
            ]
        )
    }

    static var barrel: Self {
        .init(
            tag: .equipement,
            trigger: .shot,
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

    static var willyTheKid: Self {
        .init(
            tag: .character,
            trigger: .active,
            actions: [
                .init(id: .ignorePlayLimit, selector: [.withPlayLimitCard("bang")])
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            tag: .character,
            trigger: .active,
            actions: [.init(id: .incrementMagnifying)]
        )
    }

    static var paulRegret: Self {
        .init(
            tag: .character,
            trigger: .active,
            actions: [
                .init(id: .incrementRemoteness)
            ]
        )
    }

    static var bartCassidy: Self {
        .init(
            tag: .character,
            trigger: .damaged,
            actions: [
                .init(
                    id: .drawDeck,
                    selector: [
                        .withTarget(.me),
                        .repeat(.perDamage)
                    ]
                )
            ]
        )
    }

    static var elGringo: Self {
        .init(
            tag: .character,
            trigger: .damaged,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .withTarget(.attacker),
                        .repeat(.perDamage),
                        .withCard(.chooseAny(.targetCard))
                    ]
                )
            ]
        )
    }

    static var suzyLafayette: Self {
        .init(
            tag: .character,
            trigger: .handEmptied,
            actions: [
                .init(
                    id: .drawDeck,
                    selector: [.withTarget(.me)]
                )
            ]
        )
    }

    static var jourdonnais: Self {
        .init(
            tag: .character,
            trigger: .shot,
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

    static var sidKetchum: Self {
        .init(
            tag: .character,
            trigger: .played,
            actions: [
                .init(
                    id: .heal,
                    selector: [
                        .askForCost(.any),
                        .askForCost(.any),
                        .withTarget(.me),
                        .withAmount(1)
                    ]
                )
            ]
        )
    }

    static var vultureSam: Self {
        .init(
            tag: .character,
            trigger: .otherEliminated,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .withTarget(.eliminated),
                        .withCard(.forEach(.targetCards))
                    ]
                )
            ]
        )
    }

    static var luckyDuke: Self {
        .init(
            tag: .character,
            trigger: .active,
            actions: [.init(id: .incrementDrawCards)]
        )
    }

    static var blackJack: Self {
        .init(
            tag: .character,
            trigger: .drawLastCardOnTurnStarted,
            actions: [
                .init(
                    id: .showLastHand,
                    selector: [.withTarget(.me)]
                ),
                .init(
                    id: .drawDeck,
                    selector: [
                        .if(.lastHandMatched(.red)),
                        .withTarget(.me)
                    ]
                )
            ]
        )
    }

    static var pedroRamirez: Self {
        .init(
            tag: .character,
            trigger: .turnStarted,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .withTarget(.chooseAny([.hasHandCards])),
                        .withCard(.chooseAny(.targetHandCard))
                    ]
                ),
                .init(
                    id: .setCardsPerTurn,
                    selector: [
                        .if(.hasStealCardOnTurnStarted),
                        .withAmount(1)
                    ]
                )
            ]
        )
    }

    static var jesseJones: Self {
        .init(
            tag: .character,
            trigger: .turnStarted,
            actions: [
                .init(
                    id: .drawDiscared,
                    selector: [
                        .withTarget(.me),
                        .withCard(.chooseAny(.discardedCard))
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
                        .withCard(.chooseAny(.discardedCard))
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
