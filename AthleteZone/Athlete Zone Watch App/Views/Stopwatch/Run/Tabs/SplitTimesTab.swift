//
//  SplitTimesTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 05.07.2024.
//

import SwiftUI

struct SplitTimesTab: View {
    var times: [(Int, TimeInterval)]

    init(times: [TimeInterval]) {
        self.times = times.enumerated().map { index, timeInterval in
            (index, timeInterval)
        }
    }

    var body: some View {
        VStack {
            Text(LocalizationKey.splitTimes.localizedKey)
                .font(.title3)

            Divider()

            ZStack {
                ScrollView {
                    ForEach(times, id: \.0) { time in
                        HStack {
                            Text("\(time.0 + 1).")
                            Text(time.1.toFormattedTime())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 5)
                    }
                }
                if times.isEmpty {
                    Text(LocalizationKey.noSplitTimeAdded.localizedKey)
                        .padding([.leading, .trailing])
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, -20)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 20)
    }
}

#Preview {
    SplitTimesTab(times: [])
}
