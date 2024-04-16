//
//  CircularProgressBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct CircularProgressBar: View {
    let color: ComponentColor
    let progress: Double
    let lineWidth: CGFloat

    init(color: ComponentColor, progress: CGFloat) {
        self.color = color
        self.progress = progress
        self.lineWidth = 15
    }

    init(color: ComponentColor, progress: Double, lineWidth: CGFloat) {
        self.color = color
        self.progress = progress
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke( // 1
                    Color(color.rawValue).opacity(0.5),
                    lineWidth: lineWidth
                )
                .padding(20)
            Circle() // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color(color.rawValue),
                    style: StrokeStyle(
                        lineWidth: lineWidth + 2,
                        lineCap: .round
                    )
                )
                .padding(20)
                .rotationEffect(.degrees(-90))
                .animation(.easeIn, value: progress)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(color: .lightPink, progress: 0.34)
    }
}
