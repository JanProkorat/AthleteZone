//
//  PhoneWorkOutRunViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.09.2023.
//

import Foundation
import SwiftUI
import WidgetKit

class PhoneWorkOutRunViewModel: WorkOutRunViewModel<WorkOut> {
    private var widgetManager = WidgetDataManager.shared
    var liveActivityManager: LiveActivityProtocol
    var soundManager: SoundProtocol
    var appStorageManager: any AppStorageProtocol

    override init() {
        liveActivityManager = LiveActivityManager.shared
        soundManager = SoundManager.shared
        appStorageManager = AppStorageManager.shared

        super.init()

        // Is triggered when timer running in background enabled
        NotificationCenter.default.publisher(for: TimerManager.workoutTimerNotification)
            .sink { [weak self] _ in
                if self?.selectedFlow != nil {
                    self?.updateInterval()
                }
            }
            .store(in: &cancellables)

        // Is triggered when timer running in background disabled
        timerManager.timeElapsedPublisher
            .sink { _ in
                if self.appStorageManager.runInBackground {
                    return
                }

                if self.selectedFlow != nil {
                    self.updateInterval()
                }
            }
            .store(in: &cancellables)

        $selectedFlow
            .sink { newValue in
                self.widgetManager.saveWidgetData(self.workoutName, newValue)

                if newValue != nil {
                    self.liveActivityManager.updateActivity(
                        workFlow: newValue!,
                        workoutName: self.workoutName
                    )
                }
//                WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)

                if self.appStorageManager.soundsEnabled {
                    self.playSound(newValue)
                }
            }
            .store(in: &cancellables)
    }

    override func updateTimerOnStateChange(_ previous: WorkFlowState, _ newState: WorkFlowState) {
        if newState != previous {
            switch newState {
            case .paused:
                timerManager.stopTimer()

            case .finished:
                timerManager.stopTimer()
                selectedFlow = nil
                selectedFlowIndex = 0
                if let next = nextWorkout {
                    currentWorkout = next
                    nextWorkout = nil
                }

            case .running:
                timerManager.startTimer(1, kind: .workout, inBackground: appStorageManager.runInBackground)
                if previous == .ready {
                    liveActivityManager.startActivity(
                        workFlow: selectedFlow!,
                        workoutName: workoutName
                    )
                }

            case .quit:
                timerManager.stopTimer()
                selectedFlow = nil
                selectedFlowIndex = 0
                currentWorkout = nil
                nextWorkout = nil
                liveActivityManager.endActivity()

            default:
                break
            }
        }
    }

    func setStateAccordingToScenePhase(oldPhase: ScenePhase, newPhase: ScenePhase) {
        if appStorageManager.runInBackground {
            return
        }
        if oldPhase == ScenePhase.active && (newPhase == ScenePhase.inactive || newPhase == ScenePhase.background) {
            setState(.paused)
        }
    }
}

// MARK: Sound extension

extension PhoneWorkOutRunViewModel {
    func playSound(_ worflow: WorkFlow?) {
        if state == .running {
            if let flow = worflow {
                if flow.interval > 0 {
                    if flow.interval <= 3 && (!soundManager.isSoundPlaying || soundManager.selectedSound != .beep) {
                        soundManager.playSound(sound: .beep, numOfLoops: flow.interval - 1)
                    }
                } else {
                    if isLastRunning {
                        soundManager.playSound(sound: .fanfare, numOfLoops: 0)
                    } else {
                        soundManager.playSound(sound: .gong, numOfLoops: 0)
                    }
                }
            }
        }
    }
}
