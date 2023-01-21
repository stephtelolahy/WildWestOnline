//
//  ArgOptionImpl.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

public struct ArgOptionImpl: ArgOption {
    public let value: String
    public let label: String
    
    public init(value: String, label: String) {
        self.value = value
        self.label = label
    }
}
