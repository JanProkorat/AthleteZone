//
//  CounterText.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct CounterText: View {
    let text: String
    let size: CGFloat

    var body: some View {
        Text(text)
            .font(.custom("Lato-Italic", size: size))
            .fontWeight(.light)
            .foregroundColor(Color(Colors.MainText))
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], -15)
    }
}

struct CounterText_Previews: PreviewProvider {
    static var previews: some View {
        CounterText(text: "9:00", size: 120)
    }
}
