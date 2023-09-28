//
//  ContentViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import Combine
import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    var appStorageManager = AppStorageManager.shared
    var sectionManager = SectionManager.shared
    var connectivityManager = WatchConnectivityManager.shared

    @Published var currentSection: Section = .workout
    @Published var launchScreenState: LaunchScreenStep = .firstStep

    @Published var workoutLibraryViewModel = WorkOutLibraryViewModel()
    @Published var trainingLibraryViewModel = TrainingLibraryViewModel()
    @Published var launchScreenStateManager = LaunchScreenStateManager()

    private var cancellables = Set<AnyCancellable>()

    init() {
        appStorageManager.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                currentSection = appStorageManager.selectedSection
            }
            .store(in: &cancellables)

        connectivityManager.$isSessionReachable
            .sink { newValue in
                if newValue {
                    self.connectivityManager.requestData()
                }
            }
            .store(in: &cancellables)

        connectivityManager
            .$receivedData
            .sink { self.setReceivedData($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedNewWorkout
            .sink { self.addReceivedWorkout($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedUpdateWorkout
            .sink { self.updateReceivedWorkout($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedRemoveWorkout
            .sink { self.removeReceivedWorkout($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedNewTraining
            .sink { self.addReceivedTraining($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedUpdateTraining
            .sink { self.updateReceivedTraining($0) }
            .store(in: &cancellables)

        connectivityManager
            .$receivedRemoveTraining
            .sink { self.removeReceivedTraining($0) }
            .store(in: &cancellables)

        launchScreenStateManager
            .$state
            .sink { state in
                self.launchScreenState = state
            }
            .store(in: &cancellables)
    }
}

// MARK: Receive data

extension ContentViewModel {
    func setReceivedData(_ data: String?) {
        if let receivedDataString = data {
            do {
                let receivedData = try JSONDecoder().decode(WatchDataDto.self, from: Data(receivedDataString.utf8))
                workoutLibraryViewModel.setLibrary(receivedData.workouts)
                trainingLibraryViewModel.setLibrary(receivedData.trainings)
                launchScreenStateManager.dismiss()
            } catch {
                print(["Received data parsing error: ", error.localizedDescription])
            }
        }
    }

    func addReceivedWorkout(_ data: String?) {
        if let receivedDataString = data {
            do {
                let workout = try JSONDecoder().decode(WorkOut.self, from: Data(receivedDataString.utf8))
                workoutLibraryViewModel.addWorkout(workout)
            } catch {
                print(["Received new workout parsing error: ", error.localizedDescription])
            }
        }
    }

    func updateReceivedWorkout(_ data: String?) {
        if let receivedDataString = data {
            do {
                let workout = try JSONDecoder().decode(WorkOut.self, from: Data(receivedDataString.utf8))
                workoutLibraryViewModel.updateWorkout(workout)
            } catch {
                print(["Received updated workout parsing error: ", error.localizedDescription])
            }
        }
    }

    func removeReceivedWorkout(_ receivedId: String?) {
        if let workoutId = receivedId {
            workoutLibraryViewModel.removeWorkout(workoutId)
        }
    }

    func addReceivedTraining(_ data: String?) {
        if let receivedDataString = data {
            do {
                let training = try JSONDecoder().decode(Training.self, from: Data(receivedDataString.utf8))
                trainingLibraryViewModel.addTraining(training)
            } catch {
                print(["Received new training parsing error: ", error.localizedDescription])
            }
        }
    }

    func updateReceivedTraining(_ data: String?) {
        if let receivedDataString = data {
            do {
                let training = try JSONDecoder().decode(Training.self, from: Data(receivedDataString.utf8))
                trainingLibraryViewModel.updateTraining(training)
            } catch {
                print(["Received updated training parsing error: ", error.localizedDescription])
            }
        }
    }

    func removeReceivedTraining(_ receivedId: String?) {
        if let trainingId = receivedId {
            trainingLibraryViewModel.removeTraining(trainingId)
        }
    }
}
