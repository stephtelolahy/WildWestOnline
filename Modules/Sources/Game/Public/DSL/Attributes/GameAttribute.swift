//
//  GameAttribute.swift
//  
//
//  Created by Hugues Telolahy on 25/03/2023.
//

/// Temporary structure allowing game initizalization using DSL
public protocol GameAttribute {
    func update(game: inout GameState)
}
