////
////  TrainingContent.swift
////  Athlete Zone
////
////  Created by Jan Prokorát on 24.03.2023.
////
//
// import SwiftUI
//
// struct TrainingContent: View {
//    var training: Training
//    @State var selectedWorkout: WorkOut?
//
//    var onStartTab: (() -> Void)?
//
//    var body: some View {
//        GeometryReader { geo in
//            VStack {
//                VStack {
//                    Collapsible {
//                        Text("Description")
//                            .font(.title)
//                            .foregroundColor(Color(ComponentColor.series.rawValue))
//                    } content: {
//                        ScrollView {
//                            Text(training.trainingDescription)
//                                .font(.title2)
//                                .padding([.leading, .trailing], 5)
//                                .padding(.bottom)
//                        }
//                        .frame(maxHeight: geo.size.height * 0.2)
//                        .padding(.bottom)
//                    }
//                    .padding([.leading, .trailing], 5)
//                }
//                .background(ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(Color(ComponentColor.menu.rawValue))
//                })
//
//                ZStack(alignment: .top) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(Color(ComponentColor.menu.rawValue))
//                        .frame(height: geo.size.height * 0.07)
//                    Collapsible {
//                        Text("Workouts")
//                            .font(.title)
//                            .foregroundColor(Color(ComponentColor.rounds.rawValue))
//
//                    } content: {
//                        List {
//                            ForEach(training.workouts, id: \._id) { workout in
//                                TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.1)
//                                    .onInfoTab { selectedWorkout = workout }
//                            }
//                            .onMove { from, to in
//                                training.workouts.move(fromOffsets: from, toOffset: to)
//                            }
//                        }
//                        .listStyle(.plain)
//                    }
//                    .padding([.leading, .trailing], 5)
//                }
//
//                Spacer()
//
//                HStack {
//                    Collapsible(disabled: true, label: {
//                        Text("Summary")
//                            .font(.title)
//                            .foregroundColor(Color(ComponentColor.work.rawValue))
//                    }, content: {
//                        VStack(spacing: 7) {
//                            HStack {
//                                Text("Length")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                Text(training.trainingLength.toFormattedTime())
//                            }
//                            .padding([.leading, .trailing])
//
//                            HStack {
//                                Text("Workouts")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                Text(training.workoutCount.toFormattedNumber())
//                            }
//                            .padding([.leading, .trailing])
//                        }
//                        .padding(.bottom)
//                    })
//
//                    HStack {
//                        Button {
//                            performAction(onStartTab)
//                        } label: {
//                            Image(Icons.start.rawValue)
//                                .resizable()
//                                .scaledToFill()
//                                .foregroundColor(Color(ComponentColor.action.rawValue))
//                                .frame(maxWidth: geo.size.height * 0.15, maxHeight: geo.size.height * 0.15)
//                        }
//                    }
//                    .frame(maxWidth: geo.size.width * 0.35)
//                }
//                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.19)
//                .background(
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundColor(Color(ComponentColor.menu.rawValue))
//                    }
//                )
//            }
//            .animation(.easeOut)
//            .transition(.slide)
//            .sheet(item: $selectedWorkout) {
//                WorkoutDetailSheet(workout: $0)
//                    .presentationDetents([.fraction(0.3)])
//            }
//        }
//    }
//
//    func move(from source: IndexSet, to destination: Int) {}
// }
//
// struct TrainingContent_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainingContent(training: Training())
//    }
// }
//
// extension TrainingContent {
//    func onStartTab(action: @escaping () -> Void) -> TrainingContent {
//        var new = self
//        new.onStartTab = action
//        return new
//    }
// }
