//
//  WorkoutPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 11.07.2023.
//

import SwiftUI

struct WorkoutPicker: View {
    @Binding var selectedWorkouts: [WorkOut]
    var workoutLibrary: [WorkOut] = []

    var onCloseTab: (() -> Void)?

    var body: some View {
        DetailBaseView(title: LocalizedStringKey(LocalizationKey.selectWorkouts.rawValue)) {
            List(workoutLibrary.sorted(by: { $0.name < $1.name }), id: \._id) { workout in
                Button {
                    if let index = selectedWorkouts.firstIndex(where: { $0._id == workout._id }) {
                        selectedWorkouts.remove(at: index)
                    } else {
                        selectedWorkouts.append(workout)
                    }
                } label: {
                    listItem(item: workout)
                }
                .padding(.bottom, 130)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color(ComponentColor.darkBlue.rawValue))
            }
            .listStyle(.plain)
            .padding([.top, .bottom])
            .overlay(alignment: .top) {
                if workoutLibrary.isEmpty {
                    Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 30)
                }
            }
        }
        .onCloseTab {
            performAction(onCloseTab)
        }
    }

    @ViewBuilder
    func listItem(item: WorkOut) -> some View {
        WorkoutPickerItem(
            workOut: item,
            selectedWorkouts: $selectedWorkouts
        )
        .padding([.leading, .trailing], 2)
        .id(item._id)
    }
}

struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        let bind = Binding.constant([WorkOut]())
        WorkoutPicker(selectedWorkouts: bind, workoutLibrary: [])
    }
}

extension WorkoutPicker {
    func onCloseTab(_ handler: @escaping () -> Void) -> WorkoutPicker {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
