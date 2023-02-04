//
//  ArgResolved+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

extension Array where Element == String {
    
    func toOptions() -> [ArgOption] {
        map { ArgOptionImpl(value: $0, label: $0) }
    }
}
