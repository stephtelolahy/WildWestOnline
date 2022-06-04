//
//  ErrorNotPhase.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//

import CardGameCore

public struct ErrorIsPhase: Error, Event {
    let phase: Int
    
    public init(phase: Int) {
        self.phase = phase
    }
}
