//
//  TrainingContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

import RealmSwift
import SwiftUI

struct TrainingContent: View {
    @EnvironmentObject var viewModel: TrainingViewModel

    @State var selectedWorkout: WorkOut?

    var onStartTab: (() -> Void)?
    var onCreateTab: (() -> Void)?
    var onLibraryTab: (() -> Void)?

    var body: some View {
        GeometryReader { geo in
            VStack {
                if let selectedTraining = viewModel.selectedTraining {
                    VStack {
                        EditSection(
                            icon: "square.and.pencil.circle",
                            label: LocalizationKey.description,
                            color: ComponentColor.lightBlue
                        ) {
                            ScrollView {
                                Text(selectedTraining.trainingDescription)
                                    .font(.title2)
                                    .padding(.top, 7)
                                    .frame(maxWidth: .infinity)
                                    .padding([.leading, .trailing])
                            }
                            .frame(maxHeight: geo.size.height * 0.2)
                            .frame(maxWidth: .infinity)
                            .roundedBackground(cornerRadius: 10, color: ComponentColor.darkBlue)
                            .padding(.bottom, 7)
                        }
                    }
                    .roundedBackground(cornerRadius: 20)

                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(ComponentColor.menu.rawValue))
                            .frame(height: 50)
                        Collapsible {
                            HStack(alignment: .center) {
                                Image(systemName: "figure.run.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                                    .frame(maxWidth: 25, maxHeight: 25)
                                    .padding(.top, 5)

                                Text(LocalizationKey.workouts.localizedKey)
                                    .font(.title2)
                                    .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                                    .padding(.leading, 5)
                                    .padding(.top, 4)
                            }
                            .padding(.top, 4)

                        } content: {
                            List {
                                ForEach(viewModel.workouts, id: \._id) { workout in
                                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.07)
                                        .onInfoTab { selectedWorkout = workout }
                                }
                                .onMove { from, to in
                                    viewModel.workouts.move(fromOffsets: from, toOffset: to)
                                }
                            }
                            .listStyle(.plain)
                        }
                        .padding([.leading, .trailing], 10)
                        .padding(.top, 2)
                    }

                    Spacer()

                    HStack {
                        EditSection(
                            icon: "play.circle",
                            label: LocalizationKey.summary,
                            color: ComponentColor.lightPink,
                            disabled: true
                        ) {
                            VStack(spacing: 7) {
                                HStack {
                                    Text(LocalizationKey.length.localizedKey)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.trainingLength.toFormattedTime())
                                }
                                .padding([.leading, .trailing])

                                HStack {
                                    Text(LocalizationKey.workouts.localizedKey)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.workoutCount.toFormattedNumber())
                                }
                                .padding([.leading, .trailing])
                            }
                            .padding(.bottom)
                        }

                        HStack {
                            Button {
                                performAction(onStartTab)
                            } label: {
                                Image(Icons.start.rawValue)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(ComponentColor.action.rawValue))
                                    .frame(maxWidth: geo.size.height * 0.15, maxHeight: geo.size.height * 0.15)
                            }
                        }
                        .frame(maxWidth: geo.size.width * 0.35)
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)
                    .roundedBackground(cornerRadius: 20)
                } else {
                    VStack(alignment: .center) {
                        HStack {
                            IconButton(
                                id: "createTraining",
                                image: Icons.add.rawValue,
                                color: ComponentColor.mainText,
                                width: 100,
                                height: 100
                            )
                            .onTab { self.performAction(onCreateTab) }

                            IconButton(
                                id: "pickTraining",
                                image: Icons.book.rawValue,
                                color: ComponentColor.mainText,
                                width: 100,
                                height: 100
                            )
                            .onTab { self.performAction(onLibraryTab) }
                            .padding(.leading)
                            .padding(.top, 5)
                        }
                        Text(LocalizationKey.noTrainingSelected.localizedKey)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .sheet(item: $selectedWorkout) {
                WorkoutDetailSheet(workout: $0)
                    .presentationDetents([.fraction(0.3)])
            }
        }
    }
}

struct TrainingContent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingViewModel()
        viewModel.selectedTrainingManager.selectedTraining = Training(
            name: "name",
            description: "des cript ionwe we wwewe wew ew wewe wewewe wewew ewewe weeweweww wewewewewew",
            workouts: RealmSwift.List()
        )
        viewModel.workouts = [WorkOut()]

        return TrainingContent()
            .environmentObject(viewModel)
    }
}

extension TrainingContent {
    func onStartTab(action: @escaping () -> Void) -> TrainingContent {
        var new = self
        new.onStartTab = action
        return new
    }

    func onCreateTab(action: @escaping () -> Void) -> TrainingContent {
        var new = self
        new.onCreateTab = action
        return new
    }

    func onLibraryTab(action: @escaping () -> Void) -> TrainingContent {
        var new = self
        new.onLibraryTab = action
        return new
    }
}
