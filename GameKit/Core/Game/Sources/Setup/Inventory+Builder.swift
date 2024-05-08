//
//  Inventory+Builder.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 08/05/2024.
//

public extension Inventory {
    class Builder {
        private var figures: [String] = []
        private var cardSets: [String: [String]] = [:]
        private var cardRef: [String: Card] = [:]

        public func build() -> Inventory {
            .init(
                figures: figures,
                cardSets: cardSets,
                cardRef: cardRef
            )
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
