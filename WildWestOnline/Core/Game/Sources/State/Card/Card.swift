//
//  Card.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 20/07/2024.
//

/// Cards that are used in a game.
/// Cards can have multiple attributes,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card: Codable, Equatable {
    /// Unique Name
    public let name: String

    /// Attributes
    public let attributes: [String: Int]

    /// Abilities: included actions from another card
    public let abilities: Set<String>

    /// Ability to play card X as Y
    public let abilityToPlayCardAs: [CardAlias]

    /// Effect priority
    public let priority: Int

    /// Actions that can be performed with the card
    public let rules: [CardRule]
}

public struct CardRule: Codable, Equatable {
    /// Card effect
    let effect: CardEffect

    /// Conditions to trigger the card effect
    let playReqs: [PlayReq]
}

public struct CardAlias: Codable, Equatable {
    /// Regex of played card
    let playedRegex: String

    /// Name of card having the play effect
    let effectCard: String

    /// Conditions to trigger the card alias
    let playReqs: [PlayReq]

    public init(playedRegex: String, as effectCard: String, playReqs: [PlayReq]) {
        self.playedRegex = playedRegex
        self.effectCard = effectCard
        self.playReqs = playReqs
    }
}

/// Well known card attributes
public extension String {
    /// Max health
    static let maxHealth = "maxHealth"

    /// Gun range
    static let weapon = "weapon"

    /// Increment distance from others
    static let remoteness = "remoteness"

    /// Decrement distance to others
    static let magnifying = "magnifying"

    /// Number of flipped cards on a draw
    static let flippedCards = "flippedCards"

    /// If defined, this attribute overrides the maximum allowed hand cards at the end of his turn
    /// By default the maximum allowed hand cards is equal to health
    static let handLimit = "handLimit"
}

public extension Card {
    typealias Figure = (attributes: [String: Int], abilities: Set<String>)

    class Builder {
        private let name: String
        private var attributes: [String: Int] = [:]
        private var abilities: Set<String> = []
        private var priority: Int = Int.max
        private var rules: [CardRule] = []
        private var abilityToPlayCardAs: [CardAlias] = []

        public func build() -> Card {
            .init(
                name: name,
                attributes: attributes,
                abilities: abilities,
                abilityToPlayCardAs: abilityToPlayCardAs,
                priority: priority,
                rules: rules
            )
        }

        init(name: String) {
            self.name = name
        }

        public func withAttributes(_ value: [String: Int]) -> Self {
            attributes = attributes.merging(value) { _, new in new }
            return self
        }

        public func withPriorityIndex(_ array: [String]) -> Self {
            if let index = array.firstIndex(of: name) {
                priority = index
            }
            return self
        }

        public func withRule(_ content: CardRule) -> Self {
            rules.append(content)
            return self
        }

        public func withRule(@CardRuleBuilder content: () -> [CardRule]) -> Self {
            rules.append(contentsOf: content())
            return self
        }

        public func withAbilities(_ value: [String]) -> Self {
            abilities = abilities.union(value)
            return self
        }

        public func withPrototype(_ protypeFigure: Figure) -> Self {
            abilities = protypeFigure.abilities
            attributes = protypeFigure.attributes
            return self
        }

        public func withAbilityToPlayCardAs(_ value: [CardAlias]) -> Self {
            abilityToPlayCardAs = value
            return self
        }

        public func withoutAbility(_ value: String) -> Self {
            abilities.remove(value)
            return self
        }
    }

    static func makeBuilder(name: String) -> Builder {
        .init(name: name)
    }
}

@resultBuilder
public enum CardRuleBuilder {
    public static func buildBlock(_ components: CardRule...) -> [CardRule] {
        components
    }
}
