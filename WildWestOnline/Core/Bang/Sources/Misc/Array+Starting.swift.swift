//
//  Array+Starting.swift.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Array where Element: Equatable {
    /// Start array with given element, keeping initial order
    func starting(with element: Element) -> [Element] {
        guard let elementIndex = firstIndex(of: element) else {
            fatalError("Element \(element) not found in array \(self)")
        }

        return (0..<count).map { self[($0 + elementIndex) % count] }
    }
}
