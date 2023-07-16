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

//    @State private var shouldReloadItems = false

    var body: some View {
        BaseView {
            TitleText(text: "Select workouts", alignment: .center)
        } content: {
            ZStack(alignment: .top) {
                List(workoutLibrary, id: \._id) { workout in
                    Button {
                        if let index = selectedWorkouts.firstIndex(where: { $0._id == workout._id }) {
                            selectedWorkouts.remove(at: index)
                        } else {
                            selectedWorkouts.append(workout)
                        }
//                        shouldReloadItems.toggle()
                    } label: {
                        listItem(item: workout)
                    }
                    .padding(.bottom, 150)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Background.background.rawValue))
                }
                .listStyle(.plain)

                if workoutLibrary.isEmpty {
                    Text("No workouts to display.")
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        } footer: {}
    }

    @ViewBuilder
    func listItem(item: WorkOut) -> some View {
        WorkoutPickerItem(
            workOut: item,
            selectedWorkouts: $selectedWorkouts
        )
        .padding([.leading, .trailing], 2)
        .id(item._id)
//        .id(shouldReloadItems)
    }
}

struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        let bind = Binding.constant([WorkOut]())
        WorkoutPicker(selectedWorkouts: bind, workoutLibrary: [WorkOut(), WorkOut(), WorkOut(), WorkOut()])
    }
}
