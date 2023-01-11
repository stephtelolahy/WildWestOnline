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

extension Array where Element: Equatable {
    
    /// start array with given element, keeping initial order
    func starting(with element: Element) -> [Element] {
        guard let elementIndex = firstIndex(of: element) else {
            return self
        }
        
        return (0..<count).map { self[($0 + elementIndex) % count] }
    }
    
    /// Get next item after a given element
    func element(after element: Element) -> Element {
        starting(with: element)[1]
    }
}
