//
//  OnPlaySounds.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/11/2025.
//

import AudioClient

public enum SFX {
    public static let onPlaySound: [String: AudioClient.Sound] = [
        .stagecoach: .sfxHorseGalloping,
        .wellsFargo: .sfxHorseGalloping,
        .duel: .sfxShotgunOldSchool,
        .gatling: .sfxAutomaticMachineGun,
        .indians: .sfxPeacock,
        .brawl: .sfxPeacock
    ]
}
