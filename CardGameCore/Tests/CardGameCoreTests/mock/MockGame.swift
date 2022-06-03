//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

import Combine
import CardGameCore

class MockGame: GameProtocol {
    
    var state: CurrentValueSubject<State, Never>
    
    var inputCallback: ((Move) -> Void)?
    
    init(_ initialState: State) {
        state = CurrentValueSubject(initialState)
    }
    
    func input(_ move: Move) {
        inputCallback?(move)
    }
    
    func loopUpdate() {}
}
