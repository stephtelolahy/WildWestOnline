//
//  PlayReqBuilder.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Foundation

@resultBuilder
public struct PlayReqBuilder {

    public static func buildBlock(_ components: PlayReq...) -> [PlayReq] {
        components
    }
}
