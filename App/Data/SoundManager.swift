//
//  SoundManager.swift
//
//
//  Created by Larissa Fazolin on 07/02/24.
//

import Foundation
import AVFAudio

class SoundManager {
    static let instance = SoundManager()
    
    private var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case gameSoundtrack
        case lightningSoundtrack
        case battleSoundtrack
        case endingSoundtrack
    }
    
    func playSound(sound: SoundOption, volume: Float = 1.0, numberOfLoops: Int = 0, completion: ((Error?) -> Void)? = nil) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {
            completion?(NSError(domain: "YourAppDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Sound file not found"]))
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = numberOfLoops
            player?.volume = volume // Set the volume here
            player?.play()
            completion?(nil)
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
            completion?(error)
        }
    }
    
    func stopCurrentSound() {
        player?.stop()
    }
    
    func currentSoundIs(_ sound: SoundOption) -> Bool {
        return player?.url?.lastPathComponent == "\(sound.rawValue).mp3"
    }

}


class EffectManager {
    static let instance = EffectManager()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case lightningSoundtrack
        case rightInterfaceEffect
        case hedgieAttack
        case hedgieDefense
        case enemyAttack
        case victoryEffect
        case defeatEffect
    }
    
    func playSound(sound: SoundOption, volume: Float = 1.0, numberOfLoops: Int = 0) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {
            print("Sound file not found for \(sound.rawValue)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = numberOfLoops
            player?.volume = volume // Set the volume here
            player?.play()
        } catch let error {
            print("Error playing sound for \(sound.rawValue): \(error.localizedDescription)")
        }
    }

}
