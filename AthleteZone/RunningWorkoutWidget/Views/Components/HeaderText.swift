//
//  HeaderText.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct HeaderText: View {
    var text: String

    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.title)
            .lineLimit(1)
    }
}

#Preview {
    HeaderText(text: "Title")
}
