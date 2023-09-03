//
//  Array+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

extension Array where Element: Equatable {

    /// Start array with given element, keeping initial order
    func starting(with element: Element) -> [Element] {
        guard let elementIndex = firstIndex(of: element) else {
            fatalError("Element \(element) not found in array \(self)")
        }

        return (0..<count).map { self[($0 + elementIndex) % count] }
    }

    /// Get next item after a given element
    func element(after element: Element) -> Element? {
        starting(with: element).dropFirst().first
    }
}

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
