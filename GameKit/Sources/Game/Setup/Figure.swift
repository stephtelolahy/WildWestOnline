//
//  Figure.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//
/// Describing figure
public struct Figure {
    public let name: String
    public let attributes: Attributes
    public let abilities: [String]

    public init(name: String, attributes: Attributes = [:], abilities: [String] = []) {
        self.name = name
        self.attributes = attributes
        self.abilities = abilities
    }
}
