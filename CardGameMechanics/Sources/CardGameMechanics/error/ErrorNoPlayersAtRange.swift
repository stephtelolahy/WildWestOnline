//
//  ErrorNoPlayersAtRange.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public struct ErrorNoPlayersAtRange: Error, Event {
    let distance: Int
    
    public init(distance: Int) {
        self.distance = distance
    }
}
