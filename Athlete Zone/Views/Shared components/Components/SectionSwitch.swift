//
//  SectionSwitch.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import SwiftUI

struct SectionSwitch: View {
    @StateObject var router = ViewRouter.shared

    var body: some View {
        Menu {
            Button(action: {
                router.currentSection = .workout
            }, label: {
                Text(LocalizedStringKey(Section.workout.rawValue))
            })
            Button(action: {
                router.currentSection = .training
            }, label: {
                Text(LocalizedStringKey(Section.training.rawValue))
            })
        } label: {
            Image(Icons.arrowDown.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .frame(maxWidth: 55, maxHeight: 50)
        }
    }
}

struct SectionSwitch_Previews: PreviewProvider {
    static var previews: some View {
        SectionSwitch()
    }
}
