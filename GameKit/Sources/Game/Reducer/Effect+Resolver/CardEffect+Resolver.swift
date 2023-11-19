//
//  CardEffect+Resolver.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 11/05/2023.
//

protocol EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction]
}

extension CardEffect {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        try resolver().resolve(state: state, ctx: ctx)
    }
}

private extension CardEffect {
    // swiftlint:disable:next cyclomatic_complexity
    func resolver() -> EffectResolver {
        switch self {
        case let .heal(amount):
            EffectJust { .heal(amount, player: $0.player()) }

        case let .damage(amount):
            EffectJust { .damage(amount, player: $0.player()) }

        case .shoot:
            EffectJust { .damage(1, player: $0.player()) }

        case .drawDeck:
            EffectJust { .drawDeck(player: $0.player()) }

        case .discover:
            EffectJust { _ in .discover }

        case .putBack:
            EffectJust { _ in .putBack }

        case .putTopDeckToDiscard:
            EffectJust { _ in .putTopDeckToDiscard }

        case .setTurn:
            EffectJust { .setTurn($0.player()) }

        case .eliminate:
            EffectJust { .eliminate(player: $0.player()) }

        case let .chooseCard(card):
            EffectChooseCard(card: card)

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case let .steal(card, toPlayer):
            EffectSteal(card: card, toPlayer: toPlayer)

        case let .passInPlay(card, toPlayer):
            EffectPassInPlay(card: card, toPlayer: toPlayer)

        case let .target(target, effect):
            EffectTarget(target: target, effect: effect)

        case let .group(effects):
            EffectGroup(effects: effects)

        case let .repeat(times, effect):
            EffectRepeat(effect: effect, times: times)

        case let .force(effect, otherwise):
            EffectForce(effect: effect, otherwise: otherwise)

        case let .challenge(challenger, effect, otherwise):
            EffectChallenge(challenger: challenger, effect: effect, otherwise: otherwise)

        case let .ignoreError(effect):
            EffectIgnoreError(effect: effect)

        case .nothing:
            EffectNone()

        case let .luck(card, regex, onSuccess, onFailure):
            EffectLuck(card: card, regex: regex, onSuccess: onSuccess, onFailure: onFailure)

        case .activateCounterCards:
            EffectActivateCounterCards()

        case .updateAttributes:
            EffectUpdateAttributes()

        case .cancelTurn:
            EffectCancelTurn()

        case .counterShoot:
            EffectCounterShoot()
        }
    }
}
