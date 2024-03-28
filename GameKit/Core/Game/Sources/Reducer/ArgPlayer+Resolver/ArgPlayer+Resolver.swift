//
//  ArgPlayer+Resolver.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

protocol ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput
}

extension ArgPlayer {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        let output = resolver().resolve(state: state, ctx: ctx)
        let pIds: [String]
        switch output {
        case let .identified(identifiers):
            pIds = identifiers

        case let .selectable(options):
            pIds = options
        }

        guard pIds.isNotEmpty else {
            throw GameError.noPlayer(self)
        }

        return output
    }

    func resolveUnique(state: GameState, ctx: EffectContext) throws -> String {
        if case let .id(pId) = self {
            return pId
        } else {
            let output = try resolve(state: state, ctx: ctx)
            guard case let .identified(pIds) = output else {
                throw GameError.noPlayer(self)
            }

            guard pIds.count == 1 else {
                fatalError("unexpected")
            }

            return pIds[0]
        }
    }

    func resolve(
        state: GameState,
        ctx: EffectContext,
        copy: @escaping (String) -> GameAction
    ) throws -> [GameAction] {
        let resolved = try resolve(state: state, ctx: ctx)
        switch resolved {
        case let .identified(pIds):
            return pIds.map { copy($0) }

        case let .selectable(pIds):
            let actions = pIds.reduce(into: [String: GameAction]()) {
                $0[$1] = copy($1)
            }

            let validoptions = try GameAction.validateOptions(
                pIds,
                actions: actions,
                state: state
            )

            let chooseOne = GameAction.chooseOne(
                .target,
                options: validoptions,
                player: ctx.sourceActor
            )

            let match = GameAction.effect(.matchAction(actions), ctx: ctx)

            return [chooseOne, match]
        }
    }
}

/// Resolved player argument
enum PlayerArgOutput {
    /// Appply effect to well known object identifiers
    case identified([String])

    /// Must choose one of given object identifiers
    case selectable([String])
}

private extension ArgPlayer {
    // swiftlint:disable:next cyclomatic_complexity
    func resolver() -> ArgPlayerResolver {
        switch self {
        case .actor:
            PlayerActor()

        case .selectReachable:
            PlayerSelectReachable()

        case .selectAt(let distance):
            PlayerSelectAt(distance: distance)

        case .selectAny:
            PlayerSelectAny()

        case .next:
            PlayerNext()

        case .damaged:
            PlayerDamaged()

        case .all:
            PlayerAll()

        case .others:
            PlayerOthers()

        case .offender:
            PlayerOffender()

        case .eliminated:
            PlayerEliminated()

        case .id:
            fatalError("unexpected")
        }
    }
}
