//
//  Inventory.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

public struct Inventory: Codable, Equatable {
    public let figures: [String]
    public let cardSets: [String: [String]]
    public let cardRef: [String: Card]

    public init(
        figures: [String],
        cardSets: [String: [String]],
        cardRef: [String: Card]
    ) {
        self.figures = figures
        self.cardSets = cardSets
        self.cardRef = cardRef
    }
}
