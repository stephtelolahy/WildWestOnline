//
//  Result+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension Result where Success == Void {
    static var success: Result { .success(()) }
}

extension Result {
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
    
    var isFailure: Bool {
        !isSuccess
    }
}
