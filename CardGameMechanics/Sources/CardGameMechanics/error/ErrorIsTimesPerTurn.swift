//
//  ErrorMaxTimesPerTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public struct ErrorIsTimesPerTurn: Error, Event, Equatable {
    
    let max: Int
    
    public init(max: Int) {
        self.max = max
    }
}
