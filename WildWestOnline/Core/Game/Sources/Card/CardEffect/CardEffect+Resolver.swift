//
//  CardEffect+Resolver.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/05/2023.
//

protocol EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput
}

enum EffectOutput {
    case nothing
    case push([GameAction])
    case cancel([GameAction])
    case replace(_ index: Int, with: GameAction)
}

extension CardEffect {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
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

        case let .shoot(missesRequired):
            EffectJust { .prepareEffect(.prepareShoot(missesRequired: missesRequired), ctx: $0) }

        case .prepareShoot:
            EffectJust { .damage(1, player: $0.targetOrActor()) }

        case .drawDeck:
            EffectJust { .drawDeck(player: $0.targetOrActor()) }

        case .discover:
            EffectJust { _ in .discover }

        case .draw:
            EffectJust { _ in .draw }

        case .startTurn:
            EffectJust { .startTurn(player: $0.targetOrActor()) }

        case .endTurn:
            EffectJust { .endTurn(player: $0.sourceActor) }

        case .eliminate:
            EffectJust { .eliminate(player: $0.targetOrActor()) }

        case .drawArena:
            EffectDrawArena()

        case .drawDiscard:
            EffectJust { .drawDiscard(player: $0.targetOrActor()) }

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case .discardPlayed:
            EffectJust { .playBrown($0.sourceCard, player: $0.sourceActor) }

        case .equip:
            EffectJust { .playEquipment($0.sourceCard, player: $0.sourceActor) }

        case .handicap:
            EffectJust { .playHandicap($0.sourceCard, target: $0.getTarget(), player: $0.sourceActor) }

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

        case .playCounterShootCards:
            EffectPlayCounterShootCards()

        case .updateAttributes:
            EffectUpdateAttributes()

        case let .matchAction(actions):
            EffectMatchAction(actions: actions)

        case .cancelTurn:
            EffectCancelTurn()

        case .counterShoot:
            EffectCounterShoot()

        case .playAbility:
            EffectJust { .playAbility($0.sourceCard, player: $0.sourceActor) }
        }
    }
}
