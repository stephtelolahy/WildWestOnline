//
//  SoundMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/09/2025.
//

import GameCore
import AudioClient

struct SoundMatcher {
    // swiftlint:disable:next cyclomatic_complexity
    func sfx(on action: GameFeature.Action) -> AudioClient.Sound? {
        guard action.selectors.isEmpty else {
            return nil
        }

        return switch action.name {
        case .shoot:
                .sfxGunLoud

        case .draw, .drawDeck, .drawDiscard, .discover, .drawDiscovered:
                .sfxSlideClosed

        case .discardHand, .discardInPlay:
                .sfxFly

        case .stealHand, .stealInPlay:
                .sfxSlap

        case .counterShot:
                .sfxWesternRicochet

        case .equip:
                .sfxShotGun

        case .handicap:
                .sfxMetalLatch

        case .passInPlay:
                .sfxFuseBurning

        case .heal:
                .sfxSlurping2

        case .damage:
                .sfxHurt

        case .eliminate:
                .sfxPain

        case .endGame:
                .sfxTaDa

        case .play:
            #warning("Set sound effects for playing card")
            switch Card.name(of: action.playedCard) {
            case "stagecoach", "wellsFargo":
                    .sfxHorseGalloping

            case "duel":
                    .sfxShotgunOldSchool

            case "gatling":
                    .sfxAutomaticMachineGun

            case "indians", "brawl":
                    .sfxPeacock

            default:
                nil
            }

        default:
            nil
        }
    }
}
