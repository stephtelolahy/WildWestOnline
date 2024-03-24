//
//  ClassNameProtocol.swift
//
//  Created by Hugues Stephano Telolahy on 25/01/2020.
//

import Foundation

/// Get a class name
///
/// example :
/// UIView.className   //=> "UIView"
/// UILabel().className //=> "UILabel"
public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        Self.className
    }
}

extension NSObject: ClassNameProtocol {
}
