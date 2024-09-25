//
//  ActionTypeResolver.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

protocol ActionTypeResolver {
    func resolve(_ effect: ResolvingEffect) throws -> GameAction
}

extension ActionType {
    func resolve(_ effect: ResolvingEffect) throws -> GameAction {
        try resolver.resolve(effect)
    }

    private var resolver: ActionTypeResolver {
        switch self {
        case .playBrown: PlayBrownResolver()
        case .playEquipment:
            fatalError()
        case .playHandicap:
            fatalError()
        case .heal: HealResolver()
        case .damage:
            fatalError()
        case .drawDeck: DrawDeckResolver()
        case .drawDiscard:
            fatalError()
        case .steal:
            fatalError()
        case .discard:
            fatalError()
        case .passInPlay:
            fatalError()
        case .draw:
            fatalError()
        case .showLastHand:
            fatalError()
        case .discover:
            fatalError()
        case .drawDiscovered:
            fatalError()
        case .undiscover:
            fatalError()
        case .startTurn:
            fatalError()
        case .endTurn:
            fatalError()
        case .eliminate:
            fatalError()
        case .shoot:
            fatalError()
        case .missed:
            fatalError()
        case .counter:
            fatalError()
        }
    }
}

struct PlayBrownResolver: ActionTypeResolver {
    func resolve(_ effect: ResolvingEffect) throws -> GameAction {
        .playBrown(effect.card, player: effect.actor)
    }
}

struct DrawDeckResolver: ActionTypeResolver {
    func resolve(_ effect: ResolvingEffect) throws -> GameAction {
        .drawDeck(player: effect.actor)
    }
}

struct HealResolver: ActionTypeResolver {
    func resolve(_ effect: ResolvingEffect) throws -> GameAction {
        .heal(1, player: effect.actor)
    }
}
