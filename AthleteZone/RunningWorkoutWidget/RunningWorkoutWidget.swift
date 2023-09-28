//
//  RunningWorkoutWidget.swift
//  RunningWorkoutWidget
//
//  Created by Jan Prokorát on 05.08.2023.
//

import Intents
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = WorkoutWidgetEntry

    func placeholder(in context: Context) -> WorkoutWidgetEntry {
        WorkoutWidgetEntry(date: Date(), workFlow: WorkFlow(), family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (WorkoutWidgetEntry) -> Void) {
        let entry = WorkoutWidgetEntry(date: Date(), workFlow: WorkFlow(), family: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        var entry: WorkoutWidgetEntry?
        let section = AppStorageManager.shared.selectedSection

        if let widgetData = WidgetDataManager.shared.loadWidgetData() {
            entry = WorkoutWidgetEntry(date: currentDate, workFlow: widgetData, family: context.family)
        } else {
            if section == .workout {
                if let workout = loadEntity(key: UserDefaultValues.workoutId.rawValue, type: WidgetWorkOut.self) {
                    entry = WorkoutWidgetEntry(date: currentDate, workout: workout, family: context.family)
                }
            }

            if section == .training {
                if let training = loadEntity(key: UserDefaultValues.trainingId.rawValue, type: WidgetTraining.self) {
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

    private func loadEntity<T: Codable>(key: String, type: T.Type) -> T? {
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
    let workout: WidgetWorkOut?
    let training: WidgetTraining?
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
    }

    init(date: Date, workFlow: WorkFlow, family: WidgetFamily) {
        self.date = date
        self.workFlow = workFlow
        self.family = family
        self.workout = nil
        self.training = nil
    }

    init(date: Date, workout: WidgetWorkOut, family: WidgetFamily) {
        self.date = date
        self.workout = workout
        self.family = family
        self.workFlow = nil
        self.training = nil
    }

    init(date: Date, training: WidgetTraining, family: WidgetFamily) {
        self.date = date
        self.training = training
        self.family = family
        self.workFlow = nil
        self.workout = nil
    }
}

struct RunningWorkoutWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let workflow = entry.workFlow {
                if entry.family == .systemMedium {
                    WidgetMediumView(workflow: workflow, name: "Title")
                } else {
                    WidgetLargeView(workflow: workflow)
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

struct RunningWorkoutWidget: Widget {
    let kind: String = "RunningWorkoutWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RunningWorkoutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Running Workout Widget")
        .description("Displays information about your running workout")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

struct RunningWorkoutWidget_Previews: PreviewProvider {
    static var previews: some View {
//        RunningWorkoutWidgetEntryView(
//            entry: WorkoutWidgetEntry(
//                date: Date(),
//                workFlow: WorkFlow(
//                    interval: 10,
//                    type: .work,
//                    round: 1,
//                    serie: 3,
//                    totalSeries: 4,
//                    totalRounds: 3
//                ),
//                family: .systemMedium
//            )
//        )
//        RunningWorkoutWidgetEntryView(
//            entry: WorkoutWidgetEntry(
//                date: Date(),
//                workout: WidgetWorkOut(
//                    id: "sadsdsa",
//                    name: "Test",
//                    work: 30,
//                    rest: 15,
//                    series: 2,
//                    rounds: 4,
//                    reset: 60,
//                    workoutLength: 40
//                ),
//                family: .systemMedium
//            )
//        )
//        RunningWorkoutWidgetEntryView(
//            entry: WorkoutWidgetEntry(
//                date: Date(),
//                training: WidgetTraining(
//                    id: "asda",
//                    name: "Test",
//                    trainingDescription: "asdasd",
//                    workoutsCount: 3,
//                    trainingLength: 138
//                ),
//                family: .systemMedium
//            )
//        )
        RunningWorkoutWidgetEntryView(
            entry: WorkoutWidgetEntry(
                date: Date(),
                family: .systemMedium
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
