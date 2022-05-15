//
//  Feedback.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import AVFoundation
import UIKit


func playNativeSound(soundPath: String) {
    var systemSoundID: UInt32 = 0
    AudioServicesCreateSystemSoundID(
        NSURL(fileURLWithPath: soundPath),
        &systemSoundID
    )
    AudioServicesPlaySystemSound(systemSoundID)
}


func playContratulations() {
    playNativeSound(soundPath: "/System/Library/Audio/UISounds/New/Fanfare.caf")
}

func playDismiss() {
    playNativeSound(soundPath: "/System/Library/Audio/UISounds/SIMToolkitNegativeACK.caf")
}

func playFavorite() {
    playNativeSound(soundPath: "/System/Library/Audio/UISounds/Tink.caf")
}

func vibrate() {
    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
}

func haptic() {
    UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
}
