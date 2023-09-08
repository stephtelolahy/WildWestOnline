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
            EffectJust { .heal(value, player: $0.get(.target)) }

        case let .damage(value):
            EffectJust { .damage(value, player: $0.get(.target)) }

        case .draw:
            EffectJust { .draw(player: $0.get(.target)) }

        case .discover:
            EffectJust { _ in .discover }

        case .setTurn:
            EffectJust { .setTurn($0.get(.target)) }

        case .eliminate:
            EffectJust { .eliminate(player: $0.get(.target)) }

        case .chooseCard:
            EffectChooseCard()

        case let .discard(card, chooser):
            EffectDiscard(card: card, chooser: chooser)

        case let .steal(card, chooser):
            EffectSteal(card: card, chooser: chooser)
            
        case let .passInplay(card, owner):
            EffectPassInPlay(card: card, owner: owner)

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
            EffectJust { _ in .cancel(arg) }

        case .evaluateGameOver:
            EffectEvaluateGameOver()

        case .evaluateAttributes:
            EffectEvaluateAttributes()

        default:
            fatalError("unimplemented effect \(self)")
        }
    }
}
