//
//  AudioPlayerManager.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import AVFoundation

class AudioPlayerManager {
    private var player: AVAudioPlayer?

    func playAlertSound() {
        // Swap "alert" for your real audio file name once you add one to Resources.
        guard let url = Bundle.main.url(forResource: "Beri_Ruang", withExtension: "mp3") else {
            print("Audio file not found, add the file to your project.")
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        // Loop indefinitely until something explicitly calls stop() — this
        // is what makes the "confirmedNo → audio keeps playing" case
        // actually visible/audible instead of just finishing on its own.
        player?.numberOfLoops = -1
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
