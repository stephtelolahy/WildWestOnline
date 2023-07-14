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
            EffectBuild { .heal(value, player: $0.get(.target)) }

        case let .damage(value):
            EffectBuild { .damage(value, player: $0.get(.target)) }

        case .draw:
            EffectBuild { .draw(player: $0.get(.target)) }

        case .discover:
            EffectBuild { _ in .discover }

        case .setTurn:
            EffectBuild { .setTurn($0.get(.target)) }

        case .eliminate:
            EffectBuild { .eliminate(player: $0.get(.target)) }

        case .chooseCard:
            EffectChooseCard()

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case let .steal(card, chooser):
            EffectSteal(card: card, chooser: chooser)
            
        case let .passInplay(card, owner):
            EffectPassInPlay(card: card, owner: owner)

            // operation on effect
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
            
        case let .cancel(arg):
            EffectBuild { _ in .cancel(arg) }

        case .evaluateGameOver:
            EffectEvaluateGameOver()
            
        default:
            fatalError("unimplemented effect \(self)")
        }
    }
}
