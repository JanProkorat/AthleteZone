//
//  TrainingWorkoutListItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import SwiftUI

struct TrainingWorkoutListItem: View {
    let workout: WorkOut
    let height: CGFloat

    var onInfoTab: (() -> Void)?

    var body: some View {
        Button {
            performAction(onInfoTab)
        } label: {
            HStack {
                //            Button(action: {
                //                performAction(onInfoTab)
                //            }, label: {
                //                Image(systemName: "info.circle")
                //                    .resizable()
                //                    .scaledToFit()
                //                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                //            })
                //            .frame(width: height * 0.3, height: height * 0.3)
                Text(workout.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)

                Text(workout.workoutLength.toFormattedTime())
                    .font(.title2)

                Image(Icons.bars.rawValue)
                    .frame(width: height * 0.3, height: height * 0.3)
                    .padding(.leading)
                    .foregroundColor(Color(ComponentColor.grey.rawValue))
            }
            .padding([.leading, .trailing])
            .background(ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
                    .frame(height: height)
            })
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.bottom, 2)
            .background(Color(Background.background.rawValue))
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct TrainingWorkoutListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrainingWorkoutListItem(workout: WorkOut(), height: 50)
    }
}

extension TrainingWorkoutListItem {
    func onInfoTab(_ handler: @escaping () -> Void) -> TrainingWorkoutListItem {
        var new = self
        new.onInfoTab = handler
        return new
    }
}
