//
//  Result+Extension.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 26/10/2022.
//

extension Result {
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
}
