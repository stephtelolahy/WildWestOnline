//
//  PlayReqVerifierMain.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public struct PlayReqVerifierMain: PlayReqVerifier {
    
    public init() {}
    
    public func verify(_ playReq: PlayReq, ctx: Game) -> Result<Void, GameError> {
        switch playReq {
        case .isPlayersAtLeast:
            return VerifierIsPlayersAtLeast().verify(playReq, ctx: ctx)
            
        default:
            fatalError("unimplemented verifier for \(playReq)")
        }
    }
}
