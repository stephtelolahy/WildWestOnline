//
//  Card+Builder.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 12/05/2024.
//

public extension Card {
    class CollectibleBuilder {
        private let name: String
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

        init(name: String) {
            self.name = name
        }

        public func withAttributes(_ value: [String: Int]) -> Self {
            attributes = value
            return self
        }

        public func withPriorityIndex(_ array: [String]) -> Self {
            if let index = array.firstIndex(of: name) {
                priority = index
            }
            return self
        }

        public func withRule(@CardRuleBuilder content: () -> [CardRule]) -> Self {
            rules.append(contentsOf: content())
            return self
        }

        public func withPrototype(_ protypeRule: CardRule) -> Self {
            rules.insert(protypeRule, at: 0)
            return self
        }
    }

    static func makeBuilderForCollectible(name: String) -> CollectibleBuilder {
        .init(name: name)
    }
}
