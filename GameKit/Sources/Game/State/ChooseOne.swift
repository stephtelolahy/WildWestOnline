//
//  ChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/01/2024.
//

/// ChooseOne context
public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne context
public enum ChoiceType: Codable, Equatable {
    case card
    case player
    case counter
    case force
}
