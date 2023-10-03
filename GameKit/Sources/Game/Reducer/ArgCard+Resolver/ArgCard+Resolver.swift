//
//  ArgCard+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

protocol ArgCardResolverProtocol {
    func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?
    ) -> CardArgOutput
}

extension ArgCard {
    func resolve(
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
            let chooseOne = try GameAction.validateChooseOne(chooser: chooser, options: options, state: state)
            return [chooseOne]
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
    func resolver() -> ArgCardResolverProtocol {
        switch self {
        case .selectAny:
            CardSelectAny()
        case .selectArena:
            CardSelectArena()
        case .selectHandNamed(let name):
            CardSelectHandNamed(name: name)
        case .selectHand:
            CardSelectHand()
        case .all:
            CardAll()
        case .played:
            CardPlayed()
        case .previousInPlayWithAttribute(let key):
            CardPreviousInPlayWithAttribute(key: key)
        default:
            fatalError("No resolver found for \(self)")
        }
    }
}
