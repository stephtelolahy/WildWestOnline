//
//  GameAttributeBuilder.swift
//  
//
//  Created by Hugues Telolahy on 25/03/2023.
//

import Foundation

@resultBuilder
public struct GameAttributeBuilder {

    public static func buildBlock(_ components: GameAttribute...) -> [GameAttribute] {
        components
    }
}
