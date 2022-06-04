//
//  ErrorMaxTimesPerTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public struct ErrorIsTimesPerTurn: Error, Event {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
}
