//
//  ErrorPlayerHasNoCard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

public struct ErrorPlayerHasNoCard: Error, Event, Equatable {
    let player: String
    
    public init(player: String) {
        self.player = player
    }
}
