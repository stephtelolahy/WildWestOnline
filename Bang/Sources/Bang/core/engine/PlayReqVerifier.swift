//
//  PlayReqVerifier.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public protocol PlayReqVerifier {
    
    func verify(_ playReq: PlayReq, ctx: Game) -> Result<Void, GameError>
}
