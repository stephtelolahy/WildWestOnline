//
//  ActiveCards.swift
//  
//
//  Created by Hugues Telolahy on 05/06/2023.
//
import Foundation
import InitMacro

@Init
public struct ActiveCards: Codable, Equatable {
    public let player: String
    public let cards: [String]
}
