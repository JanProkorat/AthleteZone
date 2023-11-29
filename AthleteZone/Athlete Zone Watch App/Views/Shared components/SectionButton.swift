//
//  SectionButton.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.10.2023.
//

import SwiftUI

struct SectionButton: View {
    var title: String
    var section: Section
    var expectedSection: Section

    var onTab: (() -> Void)?

    var body: some View {
        Button {
            performAction(onTab)
        } label: {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(
                        expectedSection == section ?
                            Color(ComponentColor.darkBlue.rawValue) :
                            .white
                    )
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 25)
                        .foregroundColor(
                            expectedSection == section ?
                                Color(ComponentColor.buttonGreen.rawValue) :
                                Color(ComponentColor.darkGrey.rawValue)
                        )
                }
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SectionButton(title: "Workouts", section: .workout, expectedSection: .workout)
}

extension SectionButton {
    func onTab(_ handler: @escaping () -> Void) -> SectionButton {
        var new = self
        new.onTab = handler
        return new
    }
}
