//
//  StringBuilder.swift
//  
//
//  Created by Hugues Telolahy on 04/04/2023.
//

@resultBuilder
public struct StringBuilder {

    public static func buildBlock(_ components: String...) -> [String] {
        components
    }

    public static func buildExpression(_ string: String) -> String {
        string
    }
}
