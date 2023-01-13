//
//  Result+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension Result where Success == Void {
    static var success: Result { .success(()) }
}
