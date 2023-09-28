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
                            label: "Description",
                            color: ComponentColor.series
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
                            .roundedBackground(cornerRadius: 10, color: .darkBlue)
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
                                    .foregroundColor(Color(ComponentColor.rounds.rawValue))
                                    .frame(maxWidth: 35, maxHeight: 35)
                                    .padding(.top, 5)

                                Text(LocalizedStringKey("Workouts"))
                                    .font(.title)
                                    .foregroundColor(Color(ComponentColor.rounds.rawValue))
                                    .padding(.leading, 5)
                            }

                        } content: {
                            List {
                                ForEach(viewModel.workouts, id: \._id) { workout in
                                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.1)
                                        .onInfoTab { selectedWorkout = workout }
                                }
                                .onMove { from, to in
                                    viewModel.workouts.move(fromOffsets: from, toOffset: to)
                                }
                            }
                            .listStyle(.plain)
                        }
                        .padding([.leading, .trailing], 5)
                    }

                    Spacer()

                    HStack {
                        EditSection(
                            icon: "play.circle",
                            label: "Summary",
                            color: ComponentColor.work,
                            disabled: true
                        ) {
                            VStack(spacing: 7) {
                                HStack {
                                    Text(LocalizedStringKey("Length"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.trainingLength.toFormattedTime())
                                }
                                .padding([.leading, .trailing])

                                HStack {
                                    Text(LocalizedStringKey("Workouts"))
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
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.19)
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
                        Text("No training selected. Create new one or choose existing from the library")
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .animation(.easeOut)
            .transition(.slide)
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
