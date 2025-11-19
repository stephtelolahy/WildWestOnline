//
//  CardAssetTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 10/11/2025.
//
#if canImport(UIKit)
import Testing
import CardResources
import UIKit

struct CardAssetTest {
    @Test func eachCardHasAnImageAsset() async throws {
        for card in Cards.all where (card.type == .figure || card.type == .collectible) {
            let hasAsset = UIImage(named: card.name, in: .cardResources, with: nil) != nil
            #expect(hasAsset, "Missing image asset for card: \(card.name)")
        }
    }
}
#endif
