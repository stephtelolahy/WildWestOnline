//
//  DocumentConvertible.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Foundation

public protocol DocumentConvertible {
    var dictionary: [String: Any] { get }

    init(dictionary: [String: Any]) throws
}
