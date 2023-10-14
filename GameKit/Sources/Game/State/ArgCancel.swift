//
//  ArgCancel.swift
//  
//
//  Created by Hugues Telolahy on 02/07/2023.
//

/// Cancel action argument
public enum ArgCancel: Codable, Equatable {

    /// effect of shoot action
    case effectOfShoot

    /// Effect of a card
    case effectOfCard(String)
}
