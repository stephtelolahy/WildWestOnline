//
//  Figure.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//
import InitMacro

/// Describing figure
@Init(defaults: ["abilities": [], "attributes": [:]])
public struct Figure {
    public let name: String
    public let attributes: Attributes
    public let abilities: [String]
}
