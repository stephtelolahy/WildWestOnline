//
//  ErrorInvalidTarget.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

struct ErrorInvalidTarget: Error, Event {
    let player: String?
}
