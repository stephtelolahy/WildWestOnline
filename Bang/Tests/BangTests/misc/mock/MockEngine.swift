//
//  MockEngine.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import Combine
import Bang

class MockEngine: Engine {
    
    var state: CurrentValueSubject<Game, Never>
    var queue: [EffectNode] = []
    var inputCallback: ((Effect) -> Void)?
    
    init(_ ctx: Game) {
        self.state = CurrentValueSubject(ctx)
    }
    
    func input(_ move: Effect) {
        inputCallback?(move)
    }
    
    func start() {}
    
    func update() {}
}
