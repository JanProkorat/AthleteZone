//
//  WorkoutDetailSheet.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import SwiftUI

struct WorkoutDetailSheet: View {
    var workout: WorkOut

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
                Text(LocalizedStringKey(workout.name))
                    .font(.title)
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 80)

            HStack {
                HStack {
                    Text("Work")
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.work.rawValue))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(workout.work.toFormattedTime())
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.work.rawValue))
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                HStack {
                    Text("Series")
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.series.rawValue))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(workout.series.toFormattedNumber())
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.series.rawValue))
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .padding(.top, 30)

            HStack {
                HStack {
                    Text("Rest")
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.rest.rawValue))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(workout.rest.toFormattedTime())
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.rest.rawValue))
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                HStack {
                    Text("Rounds")
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.rounds.rawValue))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(workout.rounds.toFormattedNumber())
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.rounds.rawValue))
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .padding(.top)

            HStack {
                HStack {
                    Text("Reset")
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.reset.rawValue))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(workout.reset.toFormattedTime())
                        .font(.title2)
                        .foregroundColor(Color(ComponentColor.reset.rawValue))
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                HStack {}
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .padding(.top)

            Spacer()
        }
        .background(Color(Background.sheetBackground.rawValue))
        .environment(\.colorScheme, .dark)
    }
}

struct WorkoutDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailSheet(workout: WorkOut())
    }
}
