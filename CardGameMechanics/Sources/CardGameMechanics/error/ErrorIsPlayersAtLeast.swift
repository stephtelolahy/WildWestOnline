//
//  ErrorPlayersMustBeAtLeast.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct ErrorIsPlayersAtLeast: Error, Event {
    let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}
