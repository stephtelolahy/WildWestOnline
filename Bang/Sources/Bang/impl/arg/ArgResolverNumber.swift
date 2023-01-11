//
//  ArgResolverNumber.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

enum ArgResolverNumber {
    
    static func resolve(_ number: ArgNumber, ctx: Game) -> Int {
        switch number {
        case .numPlayers:
            return ctx.playOrder.count
            
        default:
            fatalError("unimplemented resolver for number \(number)")
        }
    }
}
