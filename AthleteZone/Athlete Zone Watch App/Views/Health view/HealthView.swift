//
//  HealthView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 10.09.2023.
//

import SwiftUI

struct HealthView: View {
    @EnvironmentObject var viewModel: WatchWorkOutRunViewModel

    var body: some View {
        BaseView(title: LocalizedStringKey(
            viewModel.state == .paused ? "Paused" : viewModel.workoutName)
        ) {
            VStack(alignment: .leading) {
//                Text(viewModel.workoutTime)
//                    .font(.title2)
//                    .foregroundColor(.yellow)
//                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text(String(format: "%.0f", viewModel.activeEnergy))
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Aktivní")
                            .font(.footnote)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("kcal")
                            .font(.footnote)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading)
                }

                HStack {
                    Text(String(format: "%.0f", viewModel.baseEnergy))
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Celkem")
                            .font(.footnote)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("kcal")
                            .font(.footnote)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading)
                }

                HStack {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                    Text(String(format: "%.0f", viewModel.activeEnergy))
                        .font(.title2)
                    Text("BPM")
                        .font(.title2)
                }
            }
            .padding([.leading, .top])

            Spacer()
        }
        .frame(height: .infinity)
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
            .environmentObject(WatchWorkOutRunViewModel())
    }
}
