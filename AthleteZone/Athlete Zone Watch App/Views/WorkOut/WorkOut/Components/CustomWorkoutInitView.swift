//
//  CustomWorkoutInitView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 26.11.2023.
//

import SwiftUI

struct CustomWorkoutInitView: View {
    @Binding var number: Int

    var body: some View {
        GeometryReader(content: { geo in
            VStack {
                Text("Define custom workout with own parameters")
                    .padding(.top, 12)
                    .padding([.leading, .trailing])

                Button {
                    number += 1
                } label: {
                    Image(Icon.start.rawValue)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color(ComponentColor.buttonGreen.rawValue))
                        .frame(maxWidth: geo.size.width * 0.5, maxHeight: geo.size.width * 0.5)
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        })
    }
}

#Preview {
    CustomWorkoutInitView(number: Binding.constant(0))
}
