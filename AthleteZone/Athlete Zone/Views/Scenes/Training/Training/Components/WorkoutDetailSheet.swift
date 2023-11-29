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
        GeometryReader(content: { geometry in
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(ComponentColor.darkGrey.rawValue), lineWidth: 3)
                        .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
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
                        Text(LocalizationKey.work.localizedKey)
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightPink.rawValue))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(workout.work.toFormattedTime())
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightPink.rawValue))
                    }
                    .frame(maxWidth: geometry.size.width * 0.7)
                    .padding([.leading, .trailing], 5)

                    HStack {
                        Text(LocalizationKey.series.localizedKey)
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(workout.series.toFormattedNumber())
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                    }
                    .frame(maxWidth: geometry.size.width * 0.3)
                    .padding([.leading, .trailing])
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
                .padding(.top, 30)

                HStack {
                    HStack {
                        Text(LocalizationKey.rest.localizedKey)
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(workout.rest.toFormattedTime())
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                    }
                    .frame(maxWidth: geometry.size.width * 0.7)
                    .padding([.leading, .trailing], 5)

                    HStack {
                        Text(LocalizationKey.rounds.localizedKey)
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(workout.rounds.toFormattedNumber())
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                    }
                    .frame(maxWidth: geometry.size.width * 0.3)
                    .padding([.leading, .trailing])
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
                .padding(.top)

                HStack {
                    HStack {
                        Text(LocalizationKey.reset.localizedKey)
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.braun.rawValue))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(workout.reset.toFormattedTime())
                            .font(.title2)
                            .foregroundColor(Color(ComponentColor.braun.rawValue))
                    }
                    .frame(maxWidth: geometry.size.width * 0.7)
                    .padding([.leading, .trailing], 5)

                    HStack {}
                        .frame(maxWidth: geometry.size.width * 0.3)
                        .padding([.leading, .trailing])
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
                .padding(.top)

                Spacer()
            }
            .background(Color(ComponentColor.darkBlue.rawValue))
            .environment(\.colorScheme, .dark)
        })
    }
}

struct WorkoutDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailSheet(workout: WorkOut())
    }
}
