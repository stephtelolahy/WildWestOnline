//
//  CardJSON.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 25/10/2025.
//


import Foundation

struct CardJSON: Codable {
    let id: String
    let name: String
    let type: String
    let desc: String?
    let effects: [EffectJSON]
}

struct EffectJSON: Codable {
    let trigger: String
    let action: String
    let amount: Int?
    let count: Int?
    let target: String?
    let condition: String?
}
