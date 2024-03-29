//
//  StopWatchViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Combine
import Foundation
import SwiftUI

class StopWatchViewModel: ObservableObject {
    var router: any ViewRoutingProtocol
    var timerManager: any TimerProtocol
    var realmManager: any StopWatchRealmManagerProtocol
    var soundManager: any SoundProtocol
    var appStorageManager: any AppStorageProtocol

    @Published var stopWatchInterval: TimeInterval = 0
    @Published var timerInterval: TimeInterval = 0
    @Published var state: WorkFlowState = .ready
    @Published var splitTimes: [TimeInterval] = []
    @Published var type: TimerType = .stopWatch

    private var cancellables = Set<AnyCancellable>()
    private var startDate: Date?

    init() {
        router = ViewRouter.shared
        timerManager = TimerManager.shared
        realmManager = StopWatchRealmManager()
        soundManager = SoundManager.shared
        appStorageManager = AppStorageManager.shared

        type = appStorageManager.stopWatchType

        // Is triggered when timer running in background enabled
        NotificationCenter.default.publisher(for: TimerManager.stopWatchTimerNotification)
            .sink { _ in
                if self.state == .running {
                    self.setInterval()
                }
            }
            .store(in: &cancellables)

        // Is triggered when timer running in background disabled
        timerManager.timeElapsedPublisher
            .sink { _ in
                if self.state == .running {
                    self.setInterval()
                }
            }
            .store(in: &cancellables)

        $state
            .sink { newState in
                self.resolveState(newState)
            }
            .store(in: &cancellables)

        $timerInterval
            .sink { newInterval in
                if self.state == .running {
                    self.playSound()
                    if newInterval == 0 {
                        self.state = .quit
                        self.soundManager.playSound(sound: .fanfare, numOfLoops: 0)
                    }
                }
            }
            .store(in: &cancellables)

        $type
            .sink { newTye in
                self.appStorageManager.stopWatchType = newTye
            }
            .store(in: &cancellables)
    }

    func setInterval() {
        switch type {
        case .stopWatch:
            stopWatchInterval = timerManager.timeElapsed

        case .timer:
            timerInterval -= 1
        }
    }

    func resolveState(_ state: WorkFlowState) {
        DispatchQueue.main.async {
            if state == .running {
                self.startDate = Date()
                self.timerManager.startTimer(
                    self.type == .stopWatch ? 0.01 : 1,
                    kind: .stopWatch,
                    inBackground: self.appStorageManager.runInBackground)
            }
            if state == .paused {
                self.timerManager.pauseTimer()
                self.soundManager.stop()
            }
            if state == .quit {
                self.quitActivity()
            }
        }
    }

    func quitActivity() {
        timerManager.stopTimer()
        if type == .stopWatch {
            if let date = startDate {
                let entity = StopWatch(startDate: date, endDate: Date(), splitTimes: splitTimes)
                realmManager.add(entity)
                startDate = nil
                stopWatchInterval = 0
            }
            splitTimes.removeAll()
        } else {
            timerInterval = 0
        }
        state = .ready
    }

    func setStateAccordingToScenePhase(oldPhase: ScenePhase, newPhase: ScenePhase) {
        if state != .running {
            return
        }

        if appStorageManager.runInBackground {
            return
        }

        if oldPhase == ScenePhase.active && (newPhase == ScenePhase.inactive || newPhase == ScenePhase.background) {
            state = .paused
        }
    }
}

extension StopWatchViewModel {
    func playSound() {
        if state != .running {
            return
        }

        if timerInterval > 3 || timerInterval == 0 {
            return
        }

        if !soundManager.isSoundPlaying || soundManager.selectedSound != .beep {
            soundManager.playSound(sound: .beep, numOfLoops: Int(timerInterval) - 1)
        }
    }
}
