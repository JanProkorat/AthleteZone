//
//  AppDelegate.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.07.2023.
//

import AVFAudio
import Foundation
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.ambient,
                mode: .default,
                options: AVAudioSession.CategoryOptions.mixWithOthers
            )

            try AVAudioSession.sharedInstance().setActive(true)
            AudioPlayer.shared.setupPlayers()
        } catch {
            print("Failed to configure audio session:", error.localizedDescription)
        }
        return true
    }
}
