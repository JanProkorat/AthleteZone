//
//  StopWatchViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Combine
import Foundation

class StopWatchViewModel: ObservableObject {
    var router: any ViewRoutingProtocol
    var timerManager: any TimerProtocol
    var realmManager: any StopWatchRealmManagerProtocol
    var soundManager: any SoundProtocol
    var appStorageManager: any AppStorageProtocol

    @Published var interval: TimeInterval = 0
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
            .sink { [weak self] _ in
                self?.setInterval()
            }
            .store(in: &cancellables)

        // Is triggered when timer running in background disabled
        timerManager.timeElapsedPublisher
            .sink { _ in
                self.setInterval()
            }
            .store(in: &cancellables)

        $state
            .sink { newState in
                self.resolveState(newState)
            }
            .store(in: &cancellables)

        $interval
            .sink { newInterval in
                if self.state == .running {
                    if self.type == .timer {
                        self.playSound()
                    }
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
            interval = timerManager.timeElapsed

        case .timer:
            interval -= 1
        }
    }

    func resolveState(_ state: WorkFlowState) {
        if state == .running {
            startDate = Date()
            timerManager.startTimer(
                type == .stopWatch ? 0.01 : 1,
                kind: .stopWatch,
                inBackground: appStorageManager.runInBackground)
        }
        if state == .paused {
            timerManager.pauseTimer()
            soundManager.stop()
        }
        if state == .quit {
            quitActivity()
        }
    }

    func quitActivity() {
        timerManager.stopTimer()
        if type == .stopWatch {
            let entity = StopWatch(startDate: startDate!, endDate: Date(), splitTimes: splitTimes)
            realmManager.add(entity)
            startDate = nil
            splitTimes.removeAll()
            interval = 0
        }
    }
}

extension StopWatchViewModel {
    func playSound() {
        if state == .running {
            if interval <= 3 && interval > 0 && (!soundManager.isSoundPlaying || soundManager.selectedSound != .beep) {
                soundManager.playSound(sound: .beep, numOfLoops: Int(interval) - 1)
            }
        }
    }
}
