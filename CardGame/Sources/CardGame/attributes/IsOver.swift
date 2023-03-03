//
//  IsOver.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
import GameDSL

public struct IsOver: Attribute {
    public let name: String = "isOver"
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}
