//
//  Card+Builder.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 12/05/2024.
//

public extension Card {
    class CollectibleBuilder {
        private var name: String = ""
        private var attributes: [String: Int] = [:]
        private var priority: Int = Int.max
        private var rules: [CardRule] = []

        public func build() -> Card {
            .init(
                name: name,
                attributes: attributes,
                abilities: [],
                abilityToPlayCardAs: [],
                priority: priority,
                rules: rules
            )
        }

        public func withName(_ value: String) -> Self {
            name = value
            return self
        }

        public func withAttributes(_ value: [String: Int]) -> Self {
            attributes = value
            return self
        }

        public func withPriority(_ value: Int) -> Self {
            priority = value
            return self
        }

        public func withRule(@CardRuleBuilder content: () -> [CardRule]) -> Self {
            rules.append(contentsOf: content())
            return self
        }

        /// Prepend rules from another card
        public func withPrototype(_ anotherCard: Card) -> Self {
            rules.insert(contentsOf: anotherCard.rules, at: 0)
            return self
        }
    }

    static func makeCollectibleBuilder() -> CollectibleBuilder {
        .init()
    }
}
