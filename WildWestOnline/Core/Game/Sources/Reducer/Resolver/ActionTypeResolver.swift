//
//  ActionTypeResolver.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

extension TriggeredAbility.ActionType {
    func resolve(_ effect: PendingAction) throws -> GameAction {
        try resolver.resolve(effect)
    }
}

private extension TriggeredAbility.ActionType {
    protocol Resolver {
        func resolve(_ effect: PendingAction) throws -> GameAction
    }

    var resolver: Resolver {
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

    struct PlayBrownResolver: Resolver {
        func resolve(_ effect: PendingAction) throws -> GameAction {
            .playBrown(effect.card, player: effect.actor)
        }
    }

    struct DrawDeckResolver: Resolver {
        func resolve(_ effect: PendingAction) throws -> GameAction {
            .drawDeck(player: effect.actor)
        }
    }

    struct HealResolver: Resolver {
        func resolve(_ effect: PendingAction) throws -> GameAction {
            let target = effect.target ?? effect.actor
            return .heal(1, player: target)
        }
    }
}

