//
//  Engine.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

import Combine

/// The game engine
public protocol Engine {
    
    /// observable game state
    var state: CurrentValueSubject<Game, Never> { get }
    
    /// handle input
    func input(_ move: Move)
}

