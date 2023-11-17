//
//  AthleteZoneWidgets.swift
//  AthleteZoneWidgets
//
//  Created by Jan Prokorát on 28.09.2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = WorkoutWidgetEntry

    func placeholder(in context: Context) -> WorkoutWidgetEntry {
        WorkoutWidgetEntry(date: Date(), workFlow: WorkFlow(), name: "Data name", family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (WorkoutWidgetEntry) -> Void) {
        let entry = WorkoutWidgetEntry(date: Date(), workFlow: WorkFlow(), name: "Data name", family: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        var entry: WorkoutWidgetEntry?
        let section = AppStorageManager.shared.selectedSection

        if let widgetData = WidgetDataManager.shared.loadWidgetData() {
            entry = WorkoutWidgetEntry(
                date: currentDate,
                workFlow: widgetData.workFlow,
                name: widgetData.name,
                family: context.family
            )
        } else {
            if section == .workout {
                if let workout = loadEntity(key: UserDefaultValues.workoutId, type: WorkOutDto.self) {
                    entry = WorkoutWidgetEntry(date: currentDate, workout: workout, family: context.family)
                }
            }

            if section == .training {
                if let training = loadEntity(key: UserDefaultValues.trainingId, type: TrainingDto.self) {
                    entry = WorkoutWidgetEntry(date: currentDate, training: training, family: context.family)
                }
            }
        }

        if entry == nil {
            entry = WorkoutWidgetEntry(date: currentDate, family: context.family)
        }

        let timeline = Timeline(entries: [entry!], policy: .atEnd)
        completion(timeline)
    }

    private func loadEntity<T: Codable>(key: UserDefaultValues, type: T.Type) -> T? {
        if let stringValue = AppStorageManager.shared.loadFromDefaults(key: key) {
            do {
                return try stringValue.decode() as T
            } catch {
                print(["Error parsing widget data", error.localizedDescription])
            }
        }
        return nil
    }
}

struct WorkoutWidgetEntry: TimelineEntry {
    let date: Date
    let workFlow: WorkFlow?
    let name: String?
    let workout: WorkOutDto?
    let training: TrainingDto?
    let family: WidgetFamily

    var isEmpty: Bool {
        workout == nil && training == nil && workFlow == nil
    }

    init(date: Date, family: WidgetFamily) {
        self.date = date
        self.family = family
        self.workFlow = nil
        self.workout = nil
        self.training = nil
        self.name = nil
    }

    init(date: Date, workFlow: WorkFlow, name: String, family: WidgetFamily) {
        self.date = date
        self.workFlow = workFlow
        self.family = family
        self.name = name
        self.workout = nil
        self.training = nil
    }

    init(date: Date, workout: WorkOutDto, family: WidgetFamily) {
        self.date = date
        self.workout = workout
        self.family = family
        self.workFlow = nil
        self.training = nil
        self.name = nil
    }

    init(date: Date, training: TrainingDto, family: WidgetFamily) {
        self.date = date
        self.training = training
        self.family = family
        self.workFlow = nil
        self.workout = nil
        self.name = nil
    }
}

struct AthleteZoneWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let workflow = entry.workFlow {
                if entry.family == .systemMedium {
                    WidgetMediumView(workflow: workflow, name: entry.name!)
                } else {
                    WidgetLargeView(workflow: workflow, name: entry.name!)
                }
            }

            if let workout = entry.workout {
                if entry.family == .systemMedium {
                    WidgetWorkoutMediumView(workout: workout)
                } else {
                    WidgetWorkoutLargeView(workout: workout)
                }
            }

            if let training = entry.training {
                if entry.family == .systemMedium {
                    WidgetTrainingMediumView(training: training)
                } else {
                    WidgetTrainingLargeView(training: training)
                }
            }

            if entry.isEmpty {
                if entry.family == .systemMedium {
                    DefaultMediumView()
                } else {
                    DefaultLargeView()
                }
            }
        }
        .containerBackground(for: .widget) {
            Color(Background.background.rawValue)
        }
    }
}

struct AthleteZoneWidget: Widget {
    let kind: String = "AthleteZoneWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AthleteZoneWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Running Workout Widget")
        .description("Displays information about your running workout")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

#Preview(as: .systemMedium) {
    AthleteZoneWidget()
} timeline: {
    WorkoutWidgetEntry(
        date: Date(),
        workFlow: WorkFlow(
            interval: 10,
            type: .work,
            round: 1,
            serie: 3,
            totalSeries: 4,
            totalRounds: 3
        ),
        name: "Test name",
        family: .systemMedium
    )
    WorkoutWidgetEntry(
        date: Date(),
        workout: WorkOutDto(
            id: "sadsdsa",
            name: "Test",
            work: 30,
            rest: 15,
            series: 2,
            rounds: 4,
            reset: 60,
            createdDate: Date(),
            workoutLength: 40
        ),
        family: .systemMedium
    )
    WorkoutWidgetEntry(
        date: Date(),
        training: TrainingDto(
            id: "asda",
            name: "Test",
            trainingDescription: "asdasd",
            workoutsCount: 3,
            trainingLength: 138,
            createdDate: Date(),
            workouts: [
                WorkOutDto(
                    id: "sadsdsa",
                    name: "Test",
                    work: 30,
                    rest: 15,
                    series: 2,
                    rounds: 4,
                    reset: 60,
                    createdDate: Date(),
                    workoutLength: 40
                ),
                WorkOutDto(
                    id: "zxczx",
                    name: "qwer",
                    work: 35,
                    rest: 20,
                    series: 3,
                    rounds: 5,
                    reset: 60,
                    createdDate: Date(),
                    workoutLength: 40
                )
            ]
        ),
        family: .systemMedium
    )
}
