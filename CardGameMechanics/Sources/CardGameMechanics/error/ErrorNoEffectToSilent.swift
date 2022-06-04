//
//  ErrorNoEffectToSilent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public struct ErrorNoEffectToSilent: Error, Event {
    let type: String
    
    public init(type: String) {
        self.type = type
    }
}
