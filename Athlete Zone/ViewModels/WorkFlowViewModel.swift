//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkFlowViewModel: ObservableObject {
    @Published var flow: [WorkFlow] = .init()
    @Published var selectedFlow: WorkFlow?

    @Published var workoutName = ""
    @Published var selectedFlowIndex = 0
    @Published var seriesCount = 0
    @Published var roundsCount = 0

    @Published var state: WorkFlowState = .ready
    @Published var appStorageManager = AppStorageManager.shared

    var isLastRunning: Bool {
        selectedFlow != nil &&
            selectedFlow!.type == .work &&
            selectedFlow!.round == roundsCount &&
            selectedFlow!.serie == seriesCount
    }

    private var timer: Timer?
    private var soundManager: SoundProtocol?
    private var hapticManager: HapticProtocol?

    private var selectedIndexCancellable: AnyCancellable?
    private var stateCancellable: AnyCancellable?
    private var flowIntervalSoundCancellable: AnyCancellable?
    private var flowIntervalHpticsCancellable: AnyCancellable?

    init() {
        soundManager = SoundManager()

        #if os(watchOS)
        hapticManager = HapticManager()
        #endif

        stateCancellable = $state.sink { self.updateTimerOnStateChange($0) }
        selectedIndexCancellable = $selectedFlowIndex.sink { self.updateFlowOnIndexChange($0) }

        flowIntervalSoundCancellable = $selectedFlow.sink { newValue in
            if self.appStorageManager.soundsEnabled {
                self.playSound(newValue)
            }
        }

        flowIntervalHpticsCancellable = $selectedFlow.sink { newValue in
            if self.appStorageManager.hapticsEnabled {
                self.playHaptic(newValue)
            }
        }
    }

    func createWorkFlow(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        workoutName = name
        seriesCount = series
        roundsCount = rounds

        flow.append(WorkFlow(interval: 10, type: .preparation, round: 1, serie: 1))
        var serieCount = 1
        var interval = 0
        for round in 1 ... rounds {
            for serie in 1 ... (series + (series - 1)) {
                interval = serie.isOdd() ? work : rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: interval - 1,
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount
                        )
                    )
                }
                if serie.isIven() {
                    serieCount += 1
                }
            }
            if round < rounds {
                flow.append(
                    WorkFlow(
                        interval: reset,
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie
                    )
                )
                serieCount = 1
            }
        }

        selectedFlow = flow[selectedFlowIndex]
    }

    func setState(_ state: WorkFlowState) {
        self.state = state
    }

    func onQuitTab() {
        selectedFlowIndex = 0
    }
}

// MARK: Timer extension

extension WorkFlowViewModel {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if self?.selectedFlow != nil {
                self?.updateInterval()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func updateInterval() {
        if selectedFlow != nil {
            if selectedFlow!.interval > 0 {
                selectedFlow!.interval -= 1
            } else {
                selectedFlowIndex += 1
            }
        }
    }

    func updateFlowOnIndexChange(_ newFlowIndex: Int) {
        if newFlowIndex < flow.count {
            selectedFlow = flow[newFlowIndex]
        } else if isLastRunning {
            setState(.finished)
        }
    }

    func updateTimerOnStateChange(_ newState: WorkFlowState) {
        switch newState {
        case .paused:
            stopTimer()

        case .finished:
            stopTimer()

        case .running:
            startTimer()

        default:
            break
        }
    }
}

// MARK: Sound extension

extension WorkFlowViewModel {
    func playSound(_ worflow: WorkFlow?) {
        if let flow = worflow {
            if flow.interval > 0 {
                if flow.interval <= 3 {
                    soundManager?.playSound(sound: .beep)
                }
            } else {
                if isLastRunning {
                    soundManager?.playSound(sound: .fanfare)
                } else {
                    soundManager?.playSound(sound: .gong)
                }
            }
        }
    }
}

// MARK: Haptic extensio

extension WorkFlowViewModel {
    func playHaptic(_ worflow: WorkFlow?) {
        if let flow = worflow {
            if flow.interval > 0 {
                if flow.interval <= 3 {
                    hapticManager?.playHaptic()
                }
            } else {
                hapticManager?.playFinishHaptic()
            }
        }
    }
}
