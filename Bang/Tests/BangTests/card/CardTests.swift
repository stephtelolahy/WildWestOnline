//
//  CardTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang
import Combine

/// Testing card features using engine
class CardTests: XCTestCase {
    
    var sut: Engine!
    var events: [Result<Effect, GameError>] = []
    var state: Game { sut.state.value }
    private var cancellables = Set<AnyCancellable>()
    
    func setupInitialState(_ ctx: Game) {
        sut = EngineImpl(ctx: ctx, resolver: EffectResolverMain())
        sut.state.sink { [weak self] in self?.events.appendNotNil($0.event) }.store(in: &cancellables)
    }
}
