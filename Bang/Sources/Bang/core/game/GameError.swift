//
//  GameError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Elementary game play error
public enum GameError: Error, Equatable {
    case playerAlreadyMaxHealth(String)
}
