//
//  PlayerAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//

/// Temporary structure allowing Player initizalization using DSL
public protocol PlayerAttribute {
    func apply(to player: inout Player)
}
