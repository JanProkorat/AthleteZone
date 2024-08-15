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
                label("Total time")
                    .padding(.top, 5)
                value(data.duration.toFormattedTime(), Color.yellow)

                Divider()

                label("Active calories")
                value("\(data.activeEnergy.rounded(toPlaces: 2)) cal", Color.red)

                Divider()

                label("Total calories")
                value("\(data.totalEnergy.rounded(toPlaces: 2)) cal", Color.red)

                Divider()

                label("Average heart rate")
                value("\(Int(data.heartRate)) BPM", Color.green)
            }
            .frame(maxWidth: .infinity)
            .presentationBackground(Color(ComponentColor.darkBlue.rawValue))
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .padding([.leading, .trailing])
        })
    }

    @ViewBuilder
    func label(_ text: String) -> some View {
        Text(text)
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
