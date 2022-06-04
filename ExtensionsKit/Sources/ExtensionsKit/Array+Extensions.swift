//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

public extension Array {
    
    mutating func append(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
}
