//
//  DescriptionBar.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct DescriptionBar: View {
    var text: String
    var color: ComponentColor

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.headline)
            .foregroundColor(Color(color.rawValue))
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 30)
                        .foregroundColor(Color(Background.listItemBackground.rawValue))
                }
            )
            .frame(maxWidth: .infinity)
            .frame(height: 30)
    }
}

#Preview {
    DescriptionBar(text: "Work: 00:30", color: ComponentColor.pink)
}
