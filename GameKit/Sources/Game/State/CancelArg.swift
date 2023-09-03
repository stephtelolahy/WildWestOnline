//
//  CancelArg.swift
//  
//
//  Created by Hugues Telolahy on 02/07/2023.
//

/// Cancel action argument
public enum CancelArg: Codable, Equatable {

    /// Next queued action
    case next

    /// Effect of given card
    case effectOfCardNamed(String)
}
