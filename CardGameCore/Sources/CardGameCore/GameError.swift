//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Displayable game play error
public protocol GameError: Event {
}

/// Custom wrapper of failable data
public enum Result<T> {
    case success(T)
    case failure(GameError)
}

public enum VoidResult {
    case success
    case failure(GameError)
}
