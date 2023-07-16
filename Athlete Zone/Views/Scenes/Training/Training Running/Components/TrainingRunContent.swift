//
//  TrainingRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.04.2023.
//

import SwiftUI

struct TrainingRunContent: View {
    @Environment(\.contentSize) var contentSize
    @EnvironmentObject var viewModel: WorkFlowViewModel

    var body: some View {
        VStack {
            Menu {
                ForEach(viewModel.workoutLibrary, id: \.id) { workout in
                    Button {
                        self.viewModel.currentWorkout = workout
                    } label: {
                        HStack {
                            Text(workout.name)
                            if workout._id == viewModel.currentWorkout?._id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(ComponentColor.yellow.rawValue))
                            }
                        }
                    }
                }
            } label: {
                HStack(alignment: .center) {
                    ZStack(alignment: .trailing) {
                        TitleText(text: viewModel.currentWorkout?.name ?? "", alignment: .center)
                        Image(Icons.arrowDown.rawValue)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                            .frame(maxWidth: 35, maxHeight: 30)
                            .padding(.trailing, 20)
                    }
                }
                .frame(height: 50)
                .roundedBackground(cornerRadius: 20)
            }

            WorkOutRunContent()
                .environmentObject(viewModel)

            Spacer()
        }
    }
}

struct TrainingRunContent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkFlowViewModel()
        viewModel.createWorkFlow([
            WorkOut("Prvni", 2, 2, 2, 2, 2),
            WorkOut("Druhy", 5, 5, 5, 5, 5)
        ])
        return TrainingRunContent()
            .environmentObject(viewModel)
            .environment(\.contentSize, CGSize(width: 100, height: 800))
    }
}
