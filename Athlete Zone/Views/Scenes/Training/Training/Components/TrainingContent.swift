//
//  TrainingContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

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
                        Collapsible {
                            Text("Description")
                                .font(.title)
                                .foregroundColor(Color(ComponentColor.series.rawValue))
                        } content: {
                            ScrollView {
                                Text(selectedTraining.trainingDescription)
                                    .font(.title2)
                                    .padding([.leading, .trailing], 5)
                                    .padding(.bottom)
                            }
                            .frame(maxHeight: geo.size.height * 0.2)
                            .padding(.bottom)
                        }
                        .padding([.leading, .trailing], 5)
                    }
                    .roundedBackground(cornerRadius: 20)

                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(ComponentColor.menu.rawValue))
                            .frame(height: geo.size.height * 0.07)
                        Collapsible {
                            Text("Workouts")
                                .font(.title)
                                .foregroundColor(Color(ComponentColor.rounds.rawValue))

                        } content: {
                            List {
                                ForEach(selectedTraining.workouts, id: \._id) { workout in
                                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.1)
                                        .onInfoTab { selectedWorkout = workout }
                                }
                                .onMove { from, to in
                                    selectedTraining.workouts.move(fromOffsets: from, toOffset: to)
                                }
                            }
                            .listStyle(.plain)
                        }
                        .padding([.leading, .trailing], 5)
                    }

                    Spacer()

                    HStack {
                        Collapsible(disabled: true, label: {
                            Text("Summary")
                                .font(.title)
                                .foregroundColor(Color(ComponentColor.work.rawValue))
                        }, content: {
                            VStack(spacing: 7) {
                                HStack {
                                    Text("Length")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.trainingLength.toFormattedTime())
                                }
                                .padding([.leading, .trailing])

                                HStack {
                                    Text("Workouts")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.workoutCount.toFormattedNumber())
                                }
                                .padding([.leading, .trailing])
                            }
                            .padding(.bottom)
                        })

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

    func move(from source: IndexSet, to destination: Int) {}
}

struct TrainingContent_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContent()
            .environmentObject(TrainingViewModel())
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
