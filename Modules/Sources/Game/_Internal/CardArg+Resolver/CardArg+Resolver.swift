//
//  CardArg+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

extension CardArg {
    func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?,
        copy: @escaping (String) -> GameAction
    ) throws -> [GameAction] {
        let resolved = resolve(
            state: state,
            ctx: ctx,
            chooser: chooser,
            owner: owner
        )
        switch resolved {
        case let .identified(cIds):
            return cIds.map { copy($0) }

        case let .selectable(cIdOptions):
            guard cIdOptions.isNotEmpty else {
                throw GameError.noCard(self)
            }

            let options = cIdOptions.reduce(into: [String: GameAction]()) {
                $0[$1.label] = copy($1.id)
            }
            let chooseOne = try GameAction.validChooseOne(chooser: chooser, options: options, state: state)
            return [chooseOne]
        }
    }

    private func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?
    ) -> CardArgOutput {
        resolver().resolve(
            state: state,
            ctx: ctx,
            chooser: chooser,
            owner: owner
        )
    }
}

protocol CardArgResolverProtocol {
    func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?
    ) -> CardArgOutput
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

private extension CardArg {
    func resolver() -> CardArgResolverProtocol {
        switch self {
        case .selectAny:
            return CardSelectAny()
        case .selectArena:
            return CardSelectArena()
        case .selectHandNamed(let name):
            return CardSelectHandNamed(name: name)
        case .selectHand:
            return CardSelectHand()
        case .all:
            return CardAll()
        case .played:
            return CardPlayed()
        default:
            fatalError("No resolver found for \(self)")
        }
    }
}
