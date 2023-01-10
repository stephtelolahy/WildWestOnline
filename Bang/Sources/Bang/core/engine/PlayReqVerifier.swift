//
//  PlayReqVerifier.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import UIKit

public protocol PlayReqVerifier {
    
    func verify(_ playReq: PlayReq, ctx: Game) -> Result<Void, GameError>
}
