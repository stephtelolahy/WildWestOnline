//
//  CardActionBuilder.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Foundation

@resultBuilder
public struct CardActionBuilder {

    public static func buildBlock(_ components: CardAction...) -> [CardAction] {
        components
    }
}
