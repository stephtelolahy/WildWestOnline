//
//  PlayerAttributeBuilder.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//

@resultBuilder
public struct PlayerAttributeBuilder {

    public static func buildBlock(_ components: PlayerAttribute...) -> [PlayerAttribute] {
        components
    }
}
