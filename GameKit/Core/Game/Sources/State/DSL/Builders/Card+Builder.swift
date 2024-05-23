//
//  Card+Builder.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 12/05/2024.
//

public extension Card {
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

public extension Card {
    struct Figure {
        let attributes: [String: Int]
        let abilities: Set<String>

        public init(attributes: [String: Int], abilities: Set<String>) {
            self.attributes = attributes
            self.abilities = abilities
        }
    }
}
