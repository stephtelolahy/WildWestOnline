//
//  PlayReqVerifierImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import UIKit

public struct PlayReqVerifierImpl: PlayReqVerifier {
    
    public init() {}
    
    public func verify(_ playReq: PlayReq, ctx: Game) -> Result<Void, GameError> {
        switch playReq {
        case let .isPlayersAtLeast(count):
            return verifyIsPlayersAtLeast(count, ctx: ctx)
            
        default:
            fatalError("unimplemented verifier for \(playReq)")
        }
    }
}

private extension PlayReqVerifierImpl {
    
    func verifyIsPlayersAtLeast(_ count: Int, ctx: Game) -> Result<Void, GameError> {
        guard ctx.playOrder.count >= count else {
            return .failure(.playersMustBeAtLeast(count))
        }
        
        return .success(())
    }
}
