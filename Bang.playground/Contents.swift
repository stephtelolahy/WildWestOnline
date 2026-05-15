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

indirect enum Effect {
    // MARK: - Logic
    case `repeat`(Repeat, Self)
    case concat([Self]) // independent effects
    case chain([Self])
    case draw(String, then: Self, else: Self? = nil)
    case askForCounter(String, Self)
    case askForRedirect(String, Self)
    case askForCost(Int, Self)

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
}

enum PlayerRef {
    case me
    case eliminated
    case i
    case attacker
    case chooseAny
    case chooseAnyAtWeaponRange
    case chooseAnyWithCard
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

extension Card {
    static let stagecoach = Card(
        onPlay: .repeat(.times(2), .drawDeck(.me))
    )

    static let wellsFargo = Card(
        onPlay: .repeat(.times(3), .drawDeck(.me))
    )

    static let beer = Card(
        onPlay: .heal(1, .me),
        canPlay: .playersAtLeast(3)
    )

    static let saloon = Card(
        onPlay: .repeat(.perPlayerWounded, .heal(1, .i))
    )

    static let catBalou = Card(
        onPlay: .discard(.chooseAnyWithCard, .chooseAnyTargetCard)
    )

    static let panic = Card(
        onPlay: .steal(.chooseAnyWithCard, .chooseAnyTargetCard, .me)
    )

    static let generalStore = Card(
        onPlay: .concat([
            .repeat(.perPlayerActive, .discover),
            .repeat(.perPlayerActive, .drawDiscovered(.chooseAnyDiscoveredCard, .i))
        ])
    )

    static let bang = Card(
        onPlay: .shoot(.chooseAnyAtWeaponRange),
        canPlay: .playLimit(1)
    )

    static let missed = Card(
        onPlay: .dodge(.me)
    )

    static let gatling = Card(
        onPlay: .repeat(.perPlayerOther, .shoot(.i))
    )

    static let indians = Card(
        onPlay: .repeat(.perPlayerOther, .askForCounter("bang", .damage(1, .i)))
    )

    static let duel = Card(
        onPlay: .askForRedirect("bang", .damage(1, .chooseAny))
    )

    static let schofield = Card(
        onActive: .setWeaponRange(2)
    )

    static let remington = Card(
        onActive: .setWeaponRange(3)
    )

    static let revCarabine = Card(
        onActive: .setWeaponRange(4)
    )

    static let winchester = Card(
        onActive: .setWeaponRange(5)
    )

    static let volcanic = Card(
        onActive: .concat([
            .setWeaponRange(1),
            .ignorePlayLimit("bang")
        ])
    )

    static let scope = Card(
        onActive: .incrementMagnifying
    )

    static let mustang = Card(
        onActive: .incrementRemoteness
    )

    static let barrel = Card(
        onShot: .draw("♥️", then: .dodge(.me))
    )

    static let dynamite = Card(
        onTurnStarted: .draw(
            "([2|3|4|5|6|7|8|9]♠️)",
            then: .concat([
                .damage(3, .me),
                .discard(.me, .sourceCard)
            ]) ,
            else: .passLeft(.sourceCard)
        )
    )

    static let jail = Card(
        onTurnStarted: .concat([
            .draw(
                "not(♥️)",
                then: .endTurn
            ),
            .discard(.me, .sourceCard)
        ])
    )

    static let willyTheKid = Card(
        onActive: .ignorePlayLimit("bang")
    )

    static let roseDoolan = Card(
        onActive: .incrementMagnifying
    )

    static let paulRegret = Card(
        onActive: .incrementRemoteness
    )

    static let bartCassidy = Card(
        onDamaged: .repeat(.perDamage, .drawDeck(.me))
    )

    static let elGringo = Card(
        onDamaged: .repeat(.perDamage, .steal(.attacker, .chooseAnyTargetCard, .me))
    )

    static let suzyLafayette = Card(
        onHandEmptied: .drawDeck(.me)
    )

    static let jourdonnais = Card(
        onShot: .draw("♥️", then: .dodge(.me))
    )

    static let sidKetchum = Card(
        onActive: .askForCost(2, .heal(1, .me))
    )

    static let vultureSam = Card(
        onOtherEliminated: .repeat(.perCardOfEliminatedPlayer, .steal(.eliminated, .i, .me))
    )

    static let luckyDuke = Card(
        onDrawRequired: .incrementDrawCards
    )

    static let blackJack = Card(
        onDrawLastCardOnTurnStarted: .concat([
            .showLastHand(.me),
            .draw("(♥️)|(♦️)", then: .drawDeck(.me))
        ])
    )

    static let pedroRamirez = Card(
        onTurnStarted: .chain([
            .steal(.chooseAnyWithHandCard, .chooseAnyTargetHandCard, .me),
            .setCardsPerTurn(1)
        ])
    )

    static let jesseJones = Card(
        onTurnStarted: .chain([
            .drawDiscared(.chooseDiscardedCard, .me),
            .setCardsPerTurn(1)
        ])
    )

    static let kitCarlson = Card(
        onTurnStarted: .chain([
            .repeat(.times(3), .discover),
            .repeat(.times(2), .drawDiscovered(.chooseAnyDiscoveredCard, .me)),
            .undiscover,
            .setCardsPerTurn(0)
        ])
    )

    static let slabTheKiller = Card(
        onShootingWithBangCard: .incrementRequiredMisses
    )

    static let calamityJanet = Card(
        onActive: .concat([
            .playAs("missed", "bang"),
            .playAs("bang", "missed")
        ])
    )
}
