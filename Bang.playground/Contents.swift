import Foundation

// MARK: - Card definition

struct CardDefinition {
    let tag: CardTag
    let when: GameEvent
    let actions: [GameAction]
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
    case shootingWithBang
    case damaged
    case emptiedHand
    case anotherPlayerEliminated
    case drawnLastCardOnTurnStarted
}

struct GameAction {
    let id: GameActionID
    var selector: [Selector] = []
}

enum GameActionID: String {
    // MARK: - Visible gameplay
    case drawFromDeck
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
    case clearDiscovered
    case drawDiscovered
    case drawDiscared
    case revealLastDrawnCard

    // MARK: - Passive Modifiers
    case increaseRequiredMisses
    case increaseMagnifying
    case increaseRemoteness
    case increaseCardsDrawn
    case setWeaponRange
    case ignoreBangPlayLimit
    case decreaseCardsPerTurn
    case allowCardToBePlayedAsAnother
}

enum Selector {
    // MARK: - Conditions
    case `if`(Requirement)
    case require(Requirement)

    // MARK: - Repeaters
    case `repeat`(RepeatCount)

    // MARK: - Reactions
    case targetMayCounter(with: HandCardRequirement)
    case targetMayRedirect(with: HandCardRequirement)
    case playerMustDiscard(HandCardRequirement)

    // MARK: - Payload
    case target(PlayerTarget)
    case card(CardTarget)
    case amount(Int)
    case aliases([String: String])

    enum RepeatCount {
        case times(Int)
        case perPlayer
        case perDamage
    }

    enum PlayerTarget {
        case me
        case eliminated
        case attacker
        case choose([PlayerRequirement])
        case every(PlayerGroup)
    }

    enum PlayerRequirement {
        case hasCards
        case hasHandCards
        case wounded
        case atDistance(Int)
        case atWeaponRange
    }

    enum PlayerGroup {
        case all
        case wounded
        case others
    }

    enum CardTarget {
        case source
        case choose(CardRequirement)
        case every(CardGroup)
    }

    enum CardRequirement {
        case fromTarget
        case fromTargetHand
        case fromDiscovered
        case topDiscard
    }

    enum CardGroup {
        case allFromTarget
    }

    indirect enum Requirement {
        case not(Self)

        case drawnCardMatches(SuitPattern)
        case lastHandMatches(SuitPattern)
        case playersAtLeast(Int)
        case playLimit(Int)
        case hasDrawDiscardOnTurnStarted
        case hasStealCardOnTurnStarted
    }

    enum SuitPattern: String {
        case hearts = "♥️"
        case red = "(♥️)|(♦️)"
        case twoToNineSpades = "([2|3|4|5|6|7|8|9]♠️)"
    }

    enum HandCardRequirement: String {
        case any
        case blue
        case bang
    }
}

// MARK: - Cards

extension CardDefinition {
    static var catBalou: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .discard,
                    selector: [
                        .target(.choose([.hasCards])),
                        .card(.choose(.fromTarget))
                    ]
                )
            ]
        )
    }

    static var panic: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .target(.choose([.atDistance(1), .hasCards])),
                        .card(.choose(.fromTarget))
                    ]
                )
            ]
        )
    }

    static var generalStore: Self {
        .init(
            tag: .brown,
            when: .played,
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
                        .target(.every(.all)),
                        .card(.choose(.fromDiscovered))
                    ]
                )
            ]
        )
    }

    static var bang: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .shoot,
                    selector: [
                        .require(.playLimit(1)),
                        .target(.choose([.atWeaponRange]))
                    ]
                )
            ]
        )
    }

    static var missed: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .dodge,
                    selector: [.target(.me)]
                )
            ]
        )
    }

    static var gatling: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .shoot,
                    selector: [
                        .target(.every(.others))
                    ]
                )
            ]
        )
    }

    static var indians: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .damage,
                    selector: [
                        .target(.every(.others)),
                        .amount(1),
                        .targetMayCounter(with: .bang)
                    ]
                )
            ]
        )
    }

    static var duel: Self {
        .init(
            tag: .brown,
            when: .played,
            actions: [
                .init(
                    id: .damage,
                    selector: [
                        .target(.choose([])),
                        .amount(1),
                        .targetMayRedirect(with: .bang)
                    ]
                )
            ]
        )
    }

    static var schofield: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.amount(2)])
            ]
        )
    }

    static var remington: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.amount(3)])
            ]
        )
    }

    static var revCarabine: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.amount(4)])
            ]
        )
    }

    static var winchester: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .setWeaponRange, selector: [.amount(5)])
            ]
        )
    }

    static var volcanic: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(
                    id: .setWeaponRange,
                    selector: [.amount(1)]
                ),
                .init(id: .ignoreBangPlayLimit)
            ]
        )
    }

    static var scope: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .increaseMagnifying)
            ]
        )
    }

    static var mustang: Self {
        .init(
            tag: .equipement,
            when: .active,
            actions: [
                .init(id: .increaseRemoteness)
            ]
        )
    }

    static var barrel: Self {
        .init(
            tag: .equipement,
            when: .shot,
            actions: [
                .init(id: .draw),
                .init(
                    id: .dodge,
                    selector: [
                        .if(.drawnCardMatches(.hearts)),
                        .target(.me)
                    ]
                )
            ]
        )
    }

    static var dynamite: Self {
        .init(
            tag: .equipement,
            when: .turnStarted,
            actions: [
                .init(id: .draw),
                .init(
                    id: .damage,
                    selector: [
                        .if(.drawnCardMatches(.twoToNineSpades)),
                        .target(.me),
                        .amount(3)
                    ]
                ),
                .init(
                    id: .discard,
                    selector: [
                        .if(.drawnCardMatches(.twoToNineSpades)),
                        .card(.source)
                    ]
                ),
                .init(
                    id: .passLeft,
                    selector: [
                        .if(.not(.drawnCardMatches(.twoToNineSpades))),
                        .card(.source)
                    ]
                )
            ]
        )
    }

    static var jail: Self {
        .init(
            tag: .handicap,
            when: .turnStarted,
            actions: [
                .init(id: .draw),
                .init(
                    id: .endTurn,
                    selector: [
                        .if(.drawnCardMatches(.hearts))
                    ]
                ),
                .init(
                    id: .discard,
                    selector: [
                        .card(.source)
                    ]
                )
            ]
        )
    }

    static var willyTheKid: Self {
        .init(
            tag: .character,
            when: .active,
            actions: [
                .init(id: .ignoreBangPlayLimit)
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            tag: .character,
            when: .active,
            actions: [.init(id: .increaseMagnifying)]
        )
    }

    static var paulRegret: Self {
        .init(
            tag: .character,
            when: .active,
            actions: [
                .init(id: .increaseRemoteness)
            ]
        )
    }

    static var bartCassidy: Self {
        .init(
            tag: .character,
            when: .damaged,
            actions: [
                .init(
                    id: .drawFromDeck,
                    selector: [
                        .target(.me),
                        .repeat(.perDamage)
                    ]
                )
            ]
        )
    }

    static var elGringo: Self {
        .init(
            tag: .character,
            when: .damaged,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .target(.attacker),
                        .repeat(.perDamage),
                        .card(.choose(.fromTarget))
                    ]
                )
            ]
        )
    }

    static var suzyLafayette: Self {
        .init(
            tag: .character,
            when: .emptiedHand,
            actions: [
                .init(
                    id: .drawFromDeck,
                    selector: [.target(.me)]
                )
            ]
        )
    }

    static var jourdonnais: Self {
        .init(
            tag: .character,
            when: .shot,
            actions: [
                .init(id: .draw),
                .init(
                    id: .dodge,
                    selector: [
                        .if(.drawnCardMatches(.hearts)),
                        .target(.me)
                    ]
                )
            ]
        )
    }

    static var sidKetchum: Self {
        .init(
            tag: .character,
            when: .played,
            actions: [
                .init(
                    id: .heal,
                    selector: [
                        .playerMustDiscard(.any),
                        .playerMustDiscard(.any),
                        .target(.me),
                        .amount(1)
                    ]
                )
            ]
        )
    }

    static var vultureSam: Self {
        .init(
            tag: .character,
            when: .anotherPlayerEliminated,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .target(.eliminated),
                        .card(.every(.allFromTarget))
                    ]
                )
            ]
        )
    }

    static var luckyDuke: Self {
        .init(
            tag: .character,
            when: .active,
            actions: [.init(id: .increaseCardsDrawn)]
        )
    }

    static var blackJack: Self {
        .init(
            tag: .character,
            when: .drawnLastCardOnTurnStarted,
            actions: [
                .init(
                    id: .revealLastDrawnCard,
                    selector: [.target(.me)]
                ),
                .init(
                    id: .drawFromDeck,
                    selector: [
                        .if(.lastHandMatches(.red)),
                        .target(.me)
                    ]
                )
            ]
        )
    }

    static var pedroRamirez: Self {
        .init(
            tag: .character,
            when: .turnStarted,
            actions: [
                .init(
                    id: .steal,
                    selector: [
                        .target(.choose([.hasHandCards])),
                        .card(.choose(.fromTargetHand))
                    ]
                ),
                .init(
                    id: .decreaseCardsPerTurn,
                    selector: [
                        .if(.hasStealCardOnTurnStarted),
                        .amount(1)
                    ]
                )
            ]
        )
    }

    static var jesseJones: Self {
        .init(
            tag: .character,
            when: .turnStarted,
            actions: [
                .init(
                    id: .drawDiscared,
                    selector: [
                        .target(.me),
                        .card(.choose(.topDiscard))
                    ]
                ),
                .init(
                    id: .decreaseCardsPerTurn,
                    selector: [
                        .if(.hasDrawDiscardOnTurnStarted),
                        .amount(1)
                    ]
                )
            ]
        )
    }

    static var kitCarlson: Self {
        .init(
            tag: .character,
            when: .turnStarted,
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
                        .target(.me),
                        .repeat(.times(2)),
                        .card(.choose(.fromDiscovered))
                    ]
                ),
                .init(id: .clearDiscovered),
                .init(
                    id: .decreaseCardsPerTurn,
                    selector: [
                        .amount(2)
                    ]
                )
            ]
        )
    }

    static var slabTheKiller: Self {
        .init(
            tag: .character,
            when: .shootingWithBang,
            actions: [
                .init(id: .increaseRequiredMisses)
            ]
        )
    }

    static var calamityJanet: Self {
        .init(
            tag: .character,
            when: .active,
            actions: [
                .init(
                    id: .allowCardToBePlayedAsAnother,
                    selector: [
                        .aliases(["missed": "bang", "bang": "missed"])
                    ]
                )
            ]
        )
    }
}
