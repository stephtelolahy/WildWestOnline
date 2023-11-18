//
//  GameOver.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//
import InitMacro

@Init
public struct GameOver: Codable, Equatable {
    public let winner: String?
}
