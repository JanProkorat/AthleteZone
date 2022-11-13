//
//  CircularProgressBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct CircularProgressBar: View {
    
    let color: String
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke( // 1
                    Color(color).opacity(0.5),
                    lineWidth: 15
                )
                .padding(20)
            Circle() // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color(color),
                    style: StrokeStyle(
                        lineWidth: 17,
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
        CircularProgressBar(color: Colors.Work, progress: 0.34)
    }
}
