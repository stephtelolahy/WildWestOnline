//
//  CardAssetTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 10/11/2025.
//
#if canImport(UIKit)
import Testing
@testable import CardResources
import UIKit

struct CardAssetTest {
    @Test func eachCardHasAnImageAsset() async throws {
        let bundle = Bundle.module
        for card in Cards.all where (card.type == .character || card.type == .playable) {
            let hasAsset = UIImage(named: card.name, in: bundle, with: nil) != nil
            #expect(hasAsset, "Missing image asset for card: \(card.name)")
        }
    }
}
#endif
