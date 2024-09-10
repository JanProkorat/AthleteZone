//
//  ActivityResultView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 29.07.2024.
//

import SwiftUI

struct ActivityResultView: View {
    var data: ActivityResultDto

    var body: some View {
        NavigationView(content: {
            ScrollView {
                label(.totalTime)
                    .padding(.top, 5)
                value(data.duration.toFormattedTime(), Color.yellow)

                Divider()

                label(.activeCalories)
                value("\(data.activeEnergy.rounded(toPlaces: 2)) kcal", Color.red)

                Divider()

                label(.totalCalories)
                value("\(data.totalEnergy.rounded(toPlaces: 2)) kcal", Color.red)

                Divider()

                label(.averageHeartRate)
                value("\(Int(data.heartRate)) BPM", Color.green)
            }
            .frame(maxWidth: .infinity)
            .presentationBackground(Color(ComponentColor.darkBlue.rawValue))
            .navigationTitle(LocalizationKey.summary.localizedKey)
            .navigationBarTitleDisplayMode(.inline)
            .padding([.leading, .trailing])
        })
    }

    @ViewBuilder
    func label(_ text: LocalizationKey) -> some View {
        Text(text.localizedKey)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func value(_ text: String, _ color: Color) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3)
            .foregroundStyle(color)
    }
}

#Preview {
    ActivityResultView(data: ActivityResultDto(
        duration: 1564.32,
        heartRate: 125.7,
        activeEnergy: 654.23,
        totalEnergy: 701.5))
}
