//
//  AudioPlayerLive.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
import Foundation
import AVFoundation

extension AudioPlayer {
    static func live(bundles: [Bundle]) -> Self {
        let actor = AudioActor(bundles: bundles)
        return Self(
            load: { try? await actor.load(sounds: $0) },
            loop: { try? await actor.play(sound: $0, loop: true) },
            play: { try? await actor.play(sound: $0) },
            pause: { try? await actor.pause(sound: $0) },
            resume: { try? await actor.resume(sound: $0) },
            setGlobalVolume: { await actor.setMusicVolume(to: $0) },
            setVolume: { try? await actor.setVolume(of: $0, to: $1) },
            stop: { try? await actor.stop(sound: $0) }
        )
    }

    private actor AudioActor {
        enum Failure: Error {
            case bufferInitializationFailed
            case soundNotLoaded(AudioPlayer.Sound)
            case soundsNotLoaded([AudioPlayer.Sound: Error])
        }

        let audioEngine: AVAudioEngine
        let bundles: [Bundle]
        var musicVolume: Float = 1.0
        var players: [Sound: AVAudioPlayer] = [:]

        init(bundles: [Bundle]) {
            self.audioEngine = AVAudioEngine()
            self.bundles = bundles
        }

        func load(sounds: [Sound]) throws {
            let sounds = sounds.filter { !self.players.keys.contains($0) }
#if os(iOS) || os(tvOS) || os(watchOS)
            try AVAudioSession.sharedInstance().setActive(true, options: [])
#endif
            var errors: [Sound: Error] = [:]
            for sound in sounds {
                for bundle in self.bundles {
                    do {
                        guard let url = bundle.url(forResource: sound, withExtension: "mp3")
                        else { continue }
                        self.players[sound] = try AVAudioPlayer(contentsOf: url)
                    } catch {
                        errors[sound] = error
                    }
                }
            }
            guard errors.isEmpty else {
                throw Failure.soundsNotLoaded(errors)
            }
        }

        func play(sound: Sound, loop: Bool = false) throws {
            guard let player = self.players[sound] else {
                throw Failure.soundNotLoaded(sound)
            }

            player.currentTime = 0
            player.numberOfLoops = loop ? -1 : 0
            player.volume = self.musicVolume
            player.play()
        }

        func stop(sound: Sound) throws {
            guard let player = self.players[sound] else {
                throw Failure.soundNotLoaded(sound)
            }

            player.stop()
        }

        func pause(sound: Sound) throws {
            guard let player = self.players[sound] else {
                throw Failure.soundNotLoaded(sound)
            }

            player.pause()
        }

        func resume(sound: Sound) throws {
            guard let player = self.players[sound] else {
                throw Failure.soundNotLoaded(sound)
            }

            player.volume = self.musicVolume
            player.play()
        }

        func setVolume(of sound: Sound, to volume: Float) throws {
            guard let player = self.players[sound] else {
                throw Failure.soundNotLoaded(sound)
            }

            player.volume = volume
        }

        func setMusicVolume(to volume: Float) {
            self.musicVolume = volume
            for (sound, _) in self.players {
                try? self.setVolume(of: sound, to: volume)
            }
        }
    }
}
