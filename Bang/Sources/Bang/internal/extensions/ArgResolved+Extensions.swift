//
//  ArgResolved+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

extension Array where Element == String {
    
    func toOptions() -> [ArgResolved.Option] {
        map { ArgResolved.Option(value: $0, label: $0) }
    }
}
