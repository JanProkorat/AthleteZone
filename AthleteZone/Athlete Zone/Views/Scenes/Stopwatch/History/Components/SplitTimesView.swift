//
//  SplitTimesView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.01.2024.
//

import RealmSwift
import SwiftUI

struct SplitTimesView: View {
    var splitTimes: RealmSwift.List<TimeInterval>

    var body: some View {
        VStack {
            Text(LocalizationKey.splitTimes.localizedKey)
                .font(.title2)
            Divider()
                .overlay(Color.white)
                .padding([.leading, .trailing])
            ScrollView {
                ForEach(splitTimes.indices, id: \.self) { index in
                    HStack {
                        Text(LocalizedStringKey("\(index + 1). Split time:"))
                            .frame(maxWidth: .infinity)

                        Text(splitTimes[index].toFormattedTime())
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                }
            }
            .frame(maxHeight: .infinity)

            Divider()
                .overlay(Color.white)
                .padding([.leading, .trailing])
        }
        .overlay(alignment: .top) {
            if splitTimes.isEmpty {
                Text(LocalizationKey.noSplitTimes.localizedKey)
                    .font(.headline)
                    .bold()
                    .padding(.top, 65)
                    .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                    .padding([.leading, .trailing])
            }
        }
    }
}

#Preview {
    SplitTimesView(splitTimes: RealmSwift.List())
}
