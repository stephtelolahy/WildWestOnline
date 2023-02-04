//
//  EngineMock.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import Combine
import GameCore

class EngineMock: Engine {
    
    var state: CurrentValueSubject<Game, Never>
    var queue: [Event]
    var inputCallback: ((Move) -> Void)?
    
    init(_ ctx: Game, queue: [Event] = []) {
        self.state = CurrentValueSubject(ctx)
        self.queue = queue
    }
    
    func input(_ move: Move) {
        inputCallback?(move)
    }
    
    func start() {}
    
    func update() {}
}
