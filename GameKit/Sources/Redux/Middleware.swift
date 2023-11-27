//
//  Middleware.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine

public typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>?
