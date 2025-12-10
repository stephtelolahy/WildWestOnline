//
//  CardLibraryKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux

public extension Dependencies {
    var cardLibrary: CardLibrary {
        get { self[CardLibraryKey.self] }
        set { self[CardLibraryKey.self] = newValue }
    }
}

private enum CardLibraryKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: CardLibrary = .noop
}

private extension CardLibrary {
    static var noop: Self {
        .init(
            cards: { [] },
            deck: { [] },
            specialSounds: { [:] }
        )
    }
}
