//
//  Array+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public extension Array where Element: Equatable {
    
    /// start array with given element, keeping initial order
    func starting(with element: Element) -> [Element] {
        guard let elementIndex = firstIndex(of: element) else {
            return self
        }
        
        return (0..<count).map { self[($0 + elementIndex) % count] }
    }
    
    /// Get next item after a given element
    func element(after element: Element) -> Element? {
        starting(with: element).dropFirst().first
    }
}