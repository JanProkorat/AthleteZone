//
//  TrainingEditView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 29.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingEditView: View {
    @Bindable var store: StoreOf<TrainingEditFeature>

    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var descriptionLineLimit: Int {
        verticalSizeClass == .compact ? 3 : 4
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                TitleText(text: store.headerText.rawValue, alignment: .center)
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.08)

                VStack {
                    EditSection(icon: "pencil.circle", label: LocalizationKey.name, color: ComponentColor.lightPink) {
                        EditField {
                            TextInput(text: $store.name.sending(\.nameUpdated))
                        }
                        .padding(.bottom)
                        .frame(maxHeight: geo.size.height * 0.07)
                    }

                    EditSection(icon: "square.and.pencil.circle",
                                label: LocalizationKey.description,
                                color: ComponentColor.lightBlue) {
                        TextField(LocalizationKey.enterDescription.localizedKey,
                                  text: $store.description.sending(\.descriptionUpdated),
                                  axis: .vertical)
                            .lineLimit(descriptionLineLimit, reservesSpace: true)
                            .textFieldStyle(EditFieldStyle())
                            .padding(.top, -10)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }

                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(ComponentColor.menu.rawValue))
                            .frame(height: 50)
                        Collapsible {
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
                                .padding(.top, 3)

                        } content: {
                            VStack {
                                Button {
                                    store.send(.addWorkoutsTapped)
                                } label: {
                                    HStack(alignment: .center) {
                                        Image(Icon.add.rawValue)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color(ComponentColor.mainText.rawValue))

                                        Text(LocalizationKey.addWorkouts.localizedKey)
                                            .font(.title2)
                                            .padding(.leading, 5)
                                            .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                                    }
                                    .background(Color(ComponentColor.darkBlue.rawValue))
                                    .frame(maxWidth: geo.size.width)
                                    .padding([.top, .bottom], 10)
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .roundedBackground(cornerRadius: 10, color: .darkBlue, border: .menu, borderWidth: 3)
                                .padding(.top, 10)
                                .padding([.leading, .trailing], 3)

                                List {
                                    ForEach(store.workouts, id: \.id) { workout in
                                        TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.07)
                                    }
                                    .onDelete { index in
                                        store.send(.remove(index))
                                    }
                                    .onMove { from, to in
                                        store.send(.move(from, to))
                                    }
                                }
                                .listStyle(.plain)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                VStack(spacing: 1) {
                    ActionButton(content: {
                        ActionView(
                            text: LocalizationKey.save,
                            color: store.saveDisabled ? .grey : .lightGreen,
                            backgoundColor: ComponentColor.menu.rawValue,
                            image: Icon.check.rawValue,
                            height: 55,
                            cornerRadius: nil
                        )
                    })
                    .onTab { store.send(.saveTapped) }
                    .disabled(store.saveDisabled)

                    ActionButton(content: {
                        ActionView(
                            text: LocalizationKey.cancel,
                            color: ComponentColor.lightPink,
                            backgoundColor: ComponentColor.menu.rawValue,
                            image: Icon.clear.rawValue,
                            height: 55,
                            cornerRadius: nil
                        )
                    })
                    .onTab { store.send(.cancelTapped) }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: geo.size.height * 0.11)
                .padding(.top)
                .padding(.bottom, 5)
            }
            .padding([.leading, .trailing], 10)
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea(.keyboard, edges: [.bottom])
        .sheet(isPresented: $store.isWorkoutsSheetVisible.sending(\.sheetVisibleChanged), content: {
            WorkoutPicker(workouts: $store.selectedWorkouts.sending(\.selectedWorkoutsChanged), workoutsLibrary: store.workoutsLibrary)
                .onCloseTab {
                    store.send(.sheetVisibleChanged(false))
                }
        })
    }

    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

#Preview {
    TrainingEditView(store: ComposableArchitecture.Store(
        initialState: TrainingEditFeature.State(
            headerText: .addTraining,
            workouts: [
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                )
            ]
        ), reducer: {
            TrainingEditFeature()
                ._printChanges()
        }
    ))
}

struct EditFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding([.leading, .trailing])
            .padding(.top, 5)
            .roundedBackground(cornerRadius: 10, color: ComponentColor.darkBlue)
            .padding()
    }
}
