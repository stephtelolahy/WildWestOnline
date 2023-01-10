//
//  playReqVerifierIsPlayersAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct VerifierIsPlayersAtLeast: PlayReqVerifier {
    
    func verify(_ playReq: PlayReq, ctx: Game) -> Result<Void, GameError> {
        guard case let .isPlayersAtLeast(count) = playReq else {
            fatalError("unexpected playReq type \(playReq)")
        }
        
        guard ctx.playOrder.count >= count else {
            return .failure(.playersMustBeAtLeast(count))
        }
        
        return .success(())
    }
}
