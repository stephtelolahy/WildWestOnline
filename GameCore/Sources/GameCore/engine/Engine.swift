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
    
    /// events queue that have to be resolved in order
    var queue: [Event] { get }
    
    /// input a move
    func input(_ move: Move)
    
    /// process event queue
    func update()
}
