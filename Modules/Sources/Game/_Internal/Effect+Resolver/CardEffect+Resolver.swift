//
//  CardEffect+Resolver.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 11/05/2023.
//

extension CardEffect {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        try resolver()
            .resolve(state: state, ctx: ctx)
    }
}

protocol EffectResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction]
}

private extension CardEffect {
    // swiftlint:disable:next cyclomatic_complexity
    func resolver() -> EffectResolverProtocol {
        switch self {
        case let .heal(value):
            return EffectBuild { .heal(value, player: $0.get(.target)) }

        case let .damage(value):
            return EffectBuild { .damage(value, player: $0.get(.target)) }

        case .draw:
            return EffectBuild { .draw(player: $0.get(.target)) }

        case .discover:
            return EffectBuild { _ in .discover }

        case .setTurn:
            return EffectBuild { .setTurn($0.get(.target)) }

        case .eliminate:
            return EffectBuild { .eliminate(player: $0.get(.target)) }

        case .chooseCard:
            return EffectChooseCard()

        case let .discard(card, chooser):
            return EffectDiscard(card: card, chooser: chooser)

        case let .steal(card, chooser):
            return EffectSteal(card: card, chooser: chooser)
            
        case let .passInplay(card, owner):
            return EffectPassInPlay(card: card, owner: owner)

            // operation on effect
        case let .target(target, effect):
            return EffectTarget(target: target, effect: effect)

        case let .group(effects):
            return EffectGroup(effects: effects)

        case let .repeat(times, effect):
            return EffectRepeat(effect: effect, times: times)

        case let .force(effect, otherwise):
            return EffectForce(effect: effect, otherwise: otherwise)

        case let .challenge(challenger, effect, otherwise):
            return EffectChallenge(challenger: challenger, effect: effect, otherwise: otherwise)
            
        case .nothing:
            return EffectNone()
            
        case let .luck(regex, onSuccess, onFailure):
            return EffectLuck(regex: regex, onSuccess: onSuccess, onFailure: onFailure)
            
        case let .cancel(arg):
            return EffectBuild { _ in .cancel(arg) }

        case .evaluateGameOver:
            return EffectEvaluateGameOver()
            
        default:
            fatalError("unimplemented effect \(self)")
        }
    }
}
