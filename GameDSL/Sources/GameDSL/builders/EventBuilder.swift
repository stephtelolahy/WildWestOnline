//
//  EventBuilder.swift
//  
//
//  Created by Hugues Telolahy on 04/03/2023.
//

@resultBuilder
public struct EventBuilder {

    public static func buildBlock(_ components: Event...) -> [Event] {
        components
    }
}
