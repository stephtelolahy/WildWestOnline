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
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func resolver() -> EffectResolver {
        switch self {
        case let .heal(amount):
            EffectJust { .heal(amount, player: $0.targetOrActor()) }

        case let .damage(amount):
            EffectJust { .damage(amount, player: $0.targetOrActor()) }

        case .shoot:
            EffectJust { .damage(1, player: $0.targetOrActor()) }

        case .drawDeck:
            EffectJust { .drawDeck(player: $0.targetOrActor()) }

        case .discover:
            EffectJust { _ in .discover }

        case .draw:
            EffectJust { _ in .draw }

        case .setTurn:
            EffectJust { .setTurn(player: $0.targetOrActor()) }

        case .eliminate:
            EffectJust { .eliminate(player: $0.targetOrActor()) }

        case .drawArena:
            EffectDrawArena()

        case .drawDiscard:
            EffectJust { .drawDiscard(player: $0.targetOrActor()) }

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case .discardPlayed:
            EffectJust { .discardPlayed($0.sourceCard, player: $0.sourceActor) }

        case .equip:
            EffectJust { .equip($0.sourceCard, player: $0.sourceActor) }

        case .handicap:
            EffectJust { .handicap($0.sourceCard, target: $0.getTarget(), player: $0.sourceActor) }

        case let .putBack(among):
            EffectPutBack(among: among)

        case .revealLastHand:
            EffectRevealLastHand()

        case let .steal(card):
            EffectSteal(card: card)

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

        case let .luck(card, regex, onSuccess, onFailure):
            EffectLuck(card: card, regex: regex, onSuccess: onSuccess, onFailure: onFailure)

        case .playCounterCards:
            EffectPlayCounterCards()

        case .updateAttributes:
            EffectUpdateAttributes()

        case .cancelTurn:
            EffectCancelTurn()

        case .counterShoot:
            EffectCounterShoot()

        case let .matchAction(actions):
            EffectMatchAction(actions: actions)
        }
    }
}
