//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct ErrorPlayersMustBeAtLeast: PlayError {
    let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}
