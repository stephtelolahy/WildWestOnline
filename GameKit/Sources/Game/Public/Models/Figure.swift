//
//  Figure.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//
import InitMacro

/// Describing figure
@Init(defaults: ["abilities": []])
public struct Figure {
    public let name: String
    public let bullets: Int
    public let abilities: [String]
}
