//
//  ContentViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import Combine
import Foundation
import SwiftUI
import WatchConnectivity

class ContentViewModel: ObservableObject {
    var settingsManager: any SettingsProtocol
    var connectivityManager: any ConnectivityProtocol
    var healthManager: any HealthProtocol

    @Published var currentSection: Section = .workout
    @Published var launchScreenState: LaunchScreenStep = .firstStep

    @Published var workoutLibraryViewModel = WorkOutLibraryViewModel()
    @Published var trainingLibraryViewModel = TrainingLibraryViewModel()
    @Published var launchScreenStateManager = LaunchScreenStateManager()

    private var cancellables = Set<AnyCancellable>()

    private var methodDictionary: [TransferDataKey: (String?) -> Void] = [:]

    init() {
        settingsManager = SettingsManager.shared
        connectivityManager = ConnectivityManager.shared
        healthManager = HealthManager.shared

        healthManager.requestAuthorization()

        settingsManager
            .currentSectionPublished
            .sink { self.currentSection = $0 }
            .store(in: &cancellables)

        connectivityManager
            .isSessionReachablePublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { self.loadData($0) }
            .store(in: &cancellables)

        connectivityManager
            .activationStatePublisher
            .sink { self.dismissLaunchScreenIfPhoneNotInstalled($0) }
            .store(in: &cancellables)

        connectivityManager
            .receivedMessagePublisher
            .sink { newValue in
                if newValue != nil {
                    self.processReceivedMessage(newValue!)
                }
            }
            .store(in: &cancellables)

        launchScreenStateManager
            .$state
            .sink { state in
                self.launchScreenState = state
            }
            .store(in: &cancellables)

        methodDictionary[.data] = { self.setReceivedData($0) }
        methodDictionary[.soundsEnabled] = { self.setRecievedSoundsEnabled($0) }
        methodDictionary[.hapticsEnabled] = { self.setRecievedHapticsEnabled($0) }
        methodDictionary[.language] = { self.setRecievedLanguage($0) }
        methodDictionary[.workoutAdd] = { self.addReceivedWorkout($0) }
        methodDictionary[.workoutEdit] = { self.updateReceivedWorkout($0) }
        methodDictionary[.workoutRemove] = { self.removeReceivedWorkout($0) }
        methodDictionary[.trainingAdd] = { self.addReceivedTraining($0) }
        methodDictionary[.trainingEdit] = { self.updateReceivedTraining($0) }
        methodDictionary[.trainingRemove] = { self.removeReceivedTraining($0) }
    }
}

// MARK: Receive data

extension ContentViewModel {
    func loadData(_ isReachable: Bool) {
        if isReachable {
            connectivityManager.requestData()
        } else {
            loadBackupData()
            launchScreenStateManager.dismiss()
        }
    }

    func dismissLaunchScreenIfPhoneNotInstalled(_ activationState: WCSessionActivationState) {
        if activationState != .activated {
            return
        }

        if !connectivityManager.isIosAppInstalled() {
            loadBackupData()
            launchScreenStateManager.dismiss()
        }
    }

    func processReceivedMessage(_ message: [String: Any]) {
        message.forEach { key, value in
            if let identifier = TransferDataKey(rawValue: key) {
                if let processMethod = methodDictionary[identifier] {
                    processMethod(value as? String)
                } else {
                    print("No process method for key \(key) defined")
                }
            } else {
                print("No \(String(describing: TransferDataKey.self)) for key \(key) defined")
            }
        }
        settingsManager.backupData(workoutLibraryViewModel.library, trainingLibraryViewModel.library)
    }

    private func setReceivedData(_ data: String?) {
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

    private func addReceivedWorkout(_ data: String?) {
        if let receivedDataString = data {
            do {
                let workout = try receivedDataString.decode() as WorkOutDto
                workoutLibraryViewModel.addWorkout(workout)
            } catch {
                print(["Received new workout parsing error: ", error.localizedDescription])
            }
        }
    }

    private func updateReceivedWorkout(_ data: String?) {
        if let receivedDataString = data {
            do {
                let workout = try receivedDataString.decode() as WorkOutDto
                workoutLibraryViewModel.updateWorkout(workout)
            } catch {
                print(["Received updated workout parsing error: ", error.localizedDescription])
            }
        }
    }

    private func removeReceivedWorkout(_ receivedId: String?) {
        if let workoutId = receivedId {
            workoutLibraryViewModel.removeWorkout(workoutId)
        }
    }

    private func addReceivedTraining(_ data: String?) {
        if let receivedDataString = data {
            do {
                let training = try receivedDataString.decode() as TrainingDto
                trainingLibraryViewModel.addTraining(training)
            } catch {
                print(["Received new training parsing error: ", error.localizedDescription])
            }
        }
    }

    private func updateReceivedTraining(_ data: String?) {
        if let receivedDataString = data {
            do {
                let training = try receivedDataString.decode() as TrainingDto
                trainingLibraryViewModel.updateTraining(training)
            } catch {
                print(["Received updated training parsing error: ", error.localizedDescription])
            }
        }
    }

    private func removeReceivedTraining(_ receivedId: String?) {
        if let trainingId = receivedId {
            trainingLibraryViewModel.removeTraining(trainingId)
        }
    }

    private func setRecievedSoundsEnabled(_ soundsEnabled: String?) {
        if let enabled = soundsEnabled {
            settingsManager.soundsEnabled = Bool(enabled) ?? false
        }
    }

    private func setRecievedHapticsEnabled(_ hapticsEnabled: String?) {
        if let enabled = hapticsEnabled {
            settingsManager.hapticsEnabled = Bool(enabled) ?? false
        }
    }

    private func setRecievedLanguage(_ language: String?) {
        if let newLanguage = language {
            settingsManager.currentLanguage = Language(rawValue: newLanguage) ?? .en
        }
    }

    private func loadBackupData() {
        if let backup = settingsManager.loadBackupData() {
            workoutLibraryViewModel.setLibrary(backup.workouts)
            trainingLibraryViewModel.setLibrary(backup.trainings)
            settingsManager.soundsEnabled = backup.soundsEnabled
            settingsManager.hapticsEnabled = backup.hapticsEnabled
            settingsManager.currentLanguage = backup.currentLanguage
            settingsManager.currentSection = backup.currentSection
        }
    }
}
