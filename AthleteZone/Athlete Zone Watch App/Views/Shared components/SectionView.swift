//
//  SectionView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 14.05.2024.
//

import SwiftUI

struct SectionView: View {
    var image: String
    var label: LocalizationKey

    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .padding([.top, .bottom], 5)
                .padding(.leading, 2)

            Text(label.localizedKey)
                .padding(.leading, 5)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionView(image: "pencil.and.list.clipboard", label: LocalizationKey.training)
}
