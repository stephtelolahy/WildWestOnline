//
//  Player+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

public extension Player {
    class Builder {
        var id: String?
        var name: String?
        var attributes: Attributes?
        var abilities: [String]?
        var health: Int?
        var hand: CardLocation?
        var inPlay: CardLocation?

        public func build() -> Player {
            guard let id else {
                fatalError("incomplete")
            }

            return Player(id: id)
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
