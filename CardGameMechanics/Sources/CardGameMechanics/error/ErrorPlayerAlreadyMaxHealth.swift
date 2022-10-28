//
//  ErrorPlayerAlreadyMaxHealth.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct ErrorPlayerAlreadyMaxHealth: Error, Event, Equatable {
    let player: String
    
    public init(player: String) {
        self.player = player
    }
}
