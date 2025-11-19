//
//  SoundMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/09/2025.
//

import GameFeature
import AudioClient

struct SoundMatcher {
    let specialSounds: [Card.ActionName: [String: AudioClient.Sound]]

    static let defaultSounds: [Card.ActionName: AudioClient.Sound] = [
        .shoot: .sfxGunLoud,
        .draw: .sfxSlideClosed,
        .drawDeck: .sfxSlideClosed,
        .drawDiscard: .sfxSlideClosed,
        .discover: .sfxSlideClosed,
        .drawDiscovered: .sfxSlideClosed,
        .showHand: .sfxSlideClosed,
        .discardHand: .sfxFly,
        .discardInPlay: .sfxFly,
        .stealHand: .sfxSlap,
        .stealInPlay: .sfxSlap,
        .counterShot: .sfxWesternRicochet,
        .equip: .sfxShotGun,
        .handicap: .sfxMetalLatch,
        .passInPlay: .sfxFuseBurning,
        .heal: .sfxSlurping2,
        .damage: .sfxHurt,
        .eliminate: .sfxPain,
        .endGame: .sfxTaDa
    ]

    func sfx(on action: GameFeature.Action) -> AudioClient.Sound? {
        guard action.isResolved else {
            return nil
        }

        if let special = specialSounds[action.name] {
            let cardName = Card.name(of: action.playedCard)
            if let sound = special[cardName] {
                return sound
            }
        }

        return Self.defaultSounds[action.name]
    }
}
