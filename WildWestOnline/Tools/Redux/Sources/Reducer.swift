//
//  Reducer.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

/// ``Reducer`` is a pure function that takes an `Action` and the current `State` to calculate the new `State`.
public typealias Reducer<State, Action> = (State, Action) -> State
