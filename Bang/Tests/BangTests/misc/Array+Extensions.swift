//
//  Array+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

extension Array {
    
    /// append a element if not `nil`
    mutating func appendNotNil(_ element: Element?) {
        if let element {
            self.append(element)
        }
    }
}
