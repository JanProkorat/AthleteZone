//
//  PhoneWorkOutRunViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.09.2023.
//

import Foundation
import WidgetKit

class PhoneWorkOutRunViewModel: WorkOutRunViewModel<WorkOut> {
    private var widgetManager = WidgetDataManager.shared
    private var liveActivityManager = LiveActivityManager.shared

    override init() {
        super.init()

        NotificationCenter.default.publisher(for: TimerManager.timerUpdatedNotification)
            .sink { [weak self] _ in
                if self?.selectedFlow != nil {
                    self?.updateInterval()
                }
            }
            .store(in: &cancellables)

        var selectedFlowPublisher: Published<WorkFlow?>.Publisher {
            $selectedFlow
        }

        $selectedFlow
            .sink { newValue in
                self.widgetManager.saveWidgetData(self.workoutName, newValue)
                WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)

                if newValue != nil {
                    self.liveActivityManager.updateActivity(
                        workFlow: newValue!,
                        workoutName: self.workoutName
                    )
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
                timerManager.startTimer()
                if previous == .ready {
                    self.liveActivityManager.startActivity(
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
                self.liveActivityManager.endActivity()

            default:
                break
            }
        }
    }
}
