//
//  GameActionBuilder.swift
//  
//
//  Created by Hugues Telolahy on 07/05/2023.
//

@resultBuilder
public struct GameActionBuilder {

    public static func buildBlock(_ components: GameAction...) -> [GameAction] {
        components
    }
}
