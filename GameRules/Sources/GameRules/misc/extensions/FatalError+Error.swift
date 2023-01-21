//
//  FatalError+Error.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2023.
//

public func fatalError(_ error: Error, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(String(describing: error), file: file, line: line)
}
