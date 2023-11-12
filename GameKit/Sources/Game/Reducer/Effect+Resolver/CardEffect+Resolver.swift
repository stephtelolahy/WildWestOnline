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
            EffectJust { .heal(amount, player: $0.target!) }

        case let .damage(amount):
            EffectJust { .damage(amount, player: $0.target!) }

        case .shoot:
            EffectJust { .damage(1, player: $0.target!) }

        case .draw:
            EffectJust { .draw(player: $0.target!) }

        case .discover:
            EffectJust { _ in .discover }

        case .setTurn:
            EffectJust { .setTurn($0.target!) }

        case .eliminate:
            EffectJust { .eliminate(player: $0.target!) }

        case let .chooseCard(card):
            EffectChooseCard(card: card)

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case let .steal(card, toPlayer):
            EffectSteal(card: card, toPlayer: toPlayer)

        case let .passInplay(card, toPlayer):
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
            
        case .nothing:
            EffectNone()
            
        case let .luck(regex, onSuccess, onFailure):
            EffectLuck(regex: regex, onSuccess: onSuccess, onFailure: onFailure)

        case .activate:
            EffectActivate()

        case .updateAttributes:
            EffectUpdateAttributes()

        case .cancelTurn:
            EffectCancelTurn()

        case .counterShoot:
            EffectCounterShoot()

        case let .revealLastDrawn(regex, onSuccess):
            EffectRevealLastDrawn(regex: regex, onSuccess: onSuccess)
        }
    }
}
