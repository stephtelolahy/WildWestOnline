//
//  Cards.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//
import CardGameCore

public enum Cards {
    
    public static let all: [Card] = [
        Card(name: "beer")
    ]
}

public extension Cards {
    
    static func get(_ name: String) -> Card {
        all.first { $0.name == name }.unsafelyUnwrapped
    }
}
