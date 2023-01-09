//
//  EffectImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

extension Effect: EffectResolving {
    
    public func resolve(ctx: Game) -> Result<[Effect], Error> {
        fatalError()
    }
}
