//
//  String+ExtractCardName.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

extension String {

    /// Extract card name from cardId
    func extractName() -> String {
        split(separator: "-").first.map(String.init) ?? self
    }
}
