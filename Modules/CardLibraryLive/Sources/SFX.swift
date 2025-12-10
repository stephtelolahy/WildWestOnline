//
//  OnPlaySounds.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/11/2025.
//

import AudioClient
import GameCore

enum SFX {
    static let specialSounds: [Card.ActionName: [String: AudioClient.Sound]] = [
        .play: [
            .stagecoach: .sfxHorseGalloping,
            .wellsFargo: .sfxHorseGalloping,
            .duel: .sfxShotgunOldSchool,
            .gatling: .sfxAutomaticMachineGun,
            .indians: .sfxPeacock,
            .brawl: .sfxPeacock
        ]
    ]
}
