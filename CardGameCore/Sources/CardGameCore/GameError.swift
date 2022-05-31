//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

#warning("rename to PlayError")

/// Displayable game play error
public protocol GameError: Event {
}

#warning("rename to PlayResult")

/// Custom wrapper of failable data
public enum Result<T> {
    case success(T)
    case failure(GameError)
}

public enum VoidResult {
    case success
    case failure(GameError)
}
