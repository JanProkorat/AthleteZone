//
//  CounterText.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.12.2022.
//

import SwiftUI

struct CounterText: View {
    let text: String
    let size: CGFloat

    var body: some View {
        Text(text)
            .scaledToFill()
            .font(Font.monospacedDigit(Font.system(size: size).weight(.light))())
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .lineLimit(1)
    }
}

struct CounterText_Previews: PreviewProvider {
    static var previews: some View {
        CounterText(text: "10:45", size: 25)
    }
}
