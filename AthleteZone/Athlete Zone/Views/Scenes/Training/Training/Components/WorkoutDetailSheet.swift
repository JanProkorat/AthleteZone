//
//  WorkoutDetailSheet.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import SwiftUI

struct WorkoutDetailSheet: View {
    @Binding var workout: WorkoutDto?

    var body: some View {
        DetailBaseView(title: workout?.name ?? "") {
            if let wrkt = workout {
                VStack(spacing: 0) {
                    HStack {
                        timeDescription(description: .work, text: wrkt.work.toFormattedTime(), color: .lightPink)
                            .padding([.leading, .trailing], 5)

                        numberDescription(description: .series, text: wrkt.series.toFormattedNumber(), color: .lightBlue)
                            .padding([.leading, .trailing])
                    }
                    .frame(maxWidth: .infinity)

                    HStack {
                        timeDescription(description: .rest, text: wrkt.rest.toFormattedTime(), color: .lightYellow)
                            .padding([.leading, .trailing], 5)

                        numberDescription(description: .rounds, text: wrkt.rounds.toFormattedNumber(), color: .lightGreen)
                            .padding([.leading, .trailing])
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                    HStack {
                        timeDescription(description: .reset, text: wrkt.reset.toFormattedTime(), color: .braun)
                            .padding([.leading, .trailing], 5)

                        HStack {}
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                }
                .padding([.top, .bottom, .leading])
            }
        }
        .onCloseTab {
            workout = nil
        }
    }

    @ViewBuilder
    private func timeDescription(description: LocalizationKey, text: String, color: ComponentColor) -> some View {
        HStack {
            HStack {
                Text(description.localizedKey)
                    .font(.title3)
                    .foregroundColor(Color(color.rawValue))
                Text(":")
                    .font(.title3)
                    .foregroundStyle(Color(color.rawValue))
                    .padding(.leading, -7)
            }

            Text(text)
                .font(.title3)
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    @ViewBuilder
    private func numberDescription(description: LocalizationKey, text: String, color: ComponentColor) -> some View {
        HStack {
            HStack {
                Text(description.localizedKey)
                    .font(.title3)
                    .foregroundColor(Color(color.rawValue))
                Text(":")
                    .font(.title3)
                    .foregroundStyle(Color(color.rawValue))
                    .padding(.leading, -7)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(text)
                .font(.title3)
                .foregroundColor(Color(color.rawValue))
        }
    }
}

struct WorkoutDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailSheet(workout: Binding.constant(WorkoutDto(
            id: "1",
            name: "Prvni",
            work: 2,
            rest: 2,
            series: 2,
            rounds: 2,
            reset: 30,
            createdDate: Date(),
            workoutLength: 50
        )))
    }
}
