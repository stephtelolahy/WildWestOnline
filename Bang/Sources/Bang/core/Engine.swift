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
    
    /// effects queue that have to be resolved in order
    var queue: [Effect] { get }
    
    /// process move
    func input(_ move: Effect)
    
    /// update game by processing event queue
    func update()
    
    /// setup queue for starting game
    func start()
}
