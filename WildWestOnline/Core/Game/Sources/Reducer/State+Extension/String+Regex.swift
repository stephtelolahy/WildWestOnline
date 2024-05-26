//
//  String+Regex.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/11/2023.
//

extension String {
    func matches(regex pattern: String) -> Bool {
        if #available(iOS 16.0, *) {
            if let regex = try? Regex(pattern),
               ranges(of: regex).isNotEmpty {
                return true
            } else {
                return false
            }
        } else {
            // Fallback on earlier versions
            fatalError("unimplemented")
        }
    }
}
