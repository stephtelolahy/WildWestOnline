//
//  ChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/01/2024.
//

/// Choice request
public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne context
public enum ChoiceType: Codable, Equatable {
    case card
    case target
    case counter
    case force
}