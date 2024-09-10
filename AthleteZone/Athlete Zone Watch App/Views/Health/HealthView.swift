//
//  HealthView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.05.2024.
//

import ComposableArchitecture
import HealthKit
import SwiftUI

struct HealthView: View {
    @Bindable var store: StoreOf<HealthFeature>

    @ObservedObject var healthManager = WatchHealthhManager.watchShared

    @State var heartRate: Double = 0
    @State var activeEnergy: Double = 0
    @State var totalEnergy: Double = 0
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(alignment: .leading) {
            TimelineView(MetricsTimelineSchedule(from: Date())) { context in
                Text(store.timeElapsed.toFormattedTime(showSubSeconds: context.cadence == .live))
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if store.hkAccessStatus == .sharingAuthorized {
                    HStack {
                        Text(String(format: "%.0f", activeEnergy))
                            .font(.title)
                            .foregroundColor(.white)

                        VStack(alignment: .leading) {
                            Text(LocalizationKey.active.localizedKey)
                                .font(.footnote)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)

                            Text("kcal")
                                .font(.footnote)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading)
                    }

                    HStack {
                        Text(String(format: "%.0f", totalEnergy))
                            .font(.title)
                            .foregroundColor(.white)

                        VStack(alignment: .leading) {
                            Text(LocalizationKey.total.localizedKey)
                                .font(.footnote)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)

                            Text("kcal")
                                .font(.footnote)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading)
                    }

                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text(String(format: "%.0f", heartRate))
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("BPM")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(LocalizationKey.healthKitAccessDescription2.localizedKey)
                }
            }
            .padding(.top, 20)
            .padding(.leading)
            .onChange(of: healthManager.totalEnergy) { _, newValue in
                totalEnergy = newValue
            }
            .onChange(of: healthManager.activeEnergy) { _, newValue in
                activeEnergy = newValue
            }
            .onChange(of: healthManager.averageHeartRate) { _, newValue in
                heartRate = newValue
            }
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
            .entries(from: startDate, mode: mode)
    }
}

#Preview {
    HealthView(
        store: ComposableArchitecture.Store(
            initialState: HealthFeature.State(hkAccessStatus: .sharingAuthorized, activityName: "Name")
        ) {
            HealthFeature()
                ._printChanges()
        }
    )
}
