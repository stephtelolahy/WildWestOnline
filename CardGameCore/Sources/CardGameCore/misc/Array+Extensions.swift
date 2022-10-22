//
//  Array+Extensions.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

public extension Array {
    
    /// append a element if not `nil`
    mutating func append(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
}

public extension Array where Element: Equatable {
    
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
