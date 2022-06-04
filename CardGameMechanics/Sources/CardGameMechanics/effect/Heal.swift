//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect {
    
    let value: Int
    
    var target: String
    
    public init(value: Int, target: String) {
        self.value = value
        self.target = target
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        .success(ctx)
    }
}
