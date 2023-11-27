//
//  Reducer.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

/// `Reducer` is a pure function that takes an action and the current state to calculate the new state.
public typealias Reducer<State> = (State, Action) -> State
