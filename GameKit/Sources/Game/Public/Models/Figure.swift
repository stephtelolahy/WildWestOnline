//
//  Figure.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//

/// Describing figure
public struct Figure {
    public let name: String
    public let bullets: Int
    public let abilities: [String]

    public init(name: String, bullets: Int, abilities: [String] = []) {
        self.name = name
        self.bullets = bullets
        self.abilities = abilities
    }
}
