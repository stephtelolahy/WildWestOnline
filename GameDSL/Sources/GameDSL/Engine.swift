//
//  Engine.swift
//  
//
//  Created by Hugues Telolahy on 02/03/2023.
//
import Combine

/// Game engine
public protocol Engine {

    /// observable game state
    var state: CurrentValueSubject<Game, Never> { get }

    /// events queue that have to be resolved in order
    var queue: [Event] { get }

    /// input a move
    func input(_ move: Event)

    /// process event queue
    func update()
}
