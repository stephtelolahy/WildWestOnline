//
//  ArgCard+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

protocol ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput
}

extension ArgCard {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        resolver().resolve(state: state, ctx: ctx)
    }

    func resolve(
        state: GameState,
        ctx: EffectContext,
        copy: @escaping (String) -> GameAction
    ) throws -> [GameAction] {
        let resolved = resolve(state: state, ctx: ctx)
        switch resolved {
        case let .identified(cIds):
            return cIds.map { copy($0) }

        case let .selectable(cIdOptions):
            guard cIdOptions.isNotEmpty else {
                throw GameError.noCard(self)
            }

            let actions = cIdOptions.reduce(into: [String: GameAction]()) {
                $0[$1.label] = copy($1.id)
            }

            let chooser = ctx.resolvingChooser ?? ctx.targetOrActor()
            return try GameAction.validateChooseOne(
                cIdOptions.map(\.label),
                actions: actions,
                chooser: chooser,
                type: .card,
                state: state,
                ctx: ctx
            )
        }
    }
}

/// Resolved card argument
enum CardArgOutput {
    /// Appply effect to well known object identifiers
    case identified([String])

    /// Must choose one of given object identifiers
    case selectable([CardArgOption])
}

/// Selectable argument option
struct CardArgOption {
    /// Identifier
    let id: String

    /// Displayed label
    let label: String
}

extension Array where Element == String {
    func toCardOptions() -> [CardArgOption] {
        map { .init(id: $0, label: $0) }
    }
}

private extension ArgCard {
    func resolver() -> ArgCardResolver {
        switch self {
        case .selectAny:
            CardSelectAny()

        case .selectArena:
            CardSelectArena()

        case .selectHandNamed(let name):
            CardSelectHandNamed(name: name)

        case .selectHand:
            CardSelectHand()

        case let .selectLastHand(count):
            CardSelectLastHand(count: count)

        case .all:
            CardAll()

        case .played:
            CardPlayed()

        case .previousInPlay(let key):
            CardPreviousInPlay(key: key)

        case .id:
            fatalError("unexpected")
        }
    }
}
