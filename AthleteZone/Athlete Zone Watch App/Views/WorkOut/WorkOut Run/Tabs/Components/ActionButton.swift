//
//  ActionButton.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 12.02.2023.
//

import SwiftUI

struct ActionButton: View {
    var icon: Icons
    var color: ComponentColor

    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            performAction(onTab)
        }, label: {
            Image(icon.rawValue)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(color.rawValue))
                .frame(width: 70, height: 70)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(icon: .start, color: .lightPink)
    }
}

extension ActionButton {
    func onTab(_ handler: @escaping () -> Void) -> ActionButton {
        var new = self
        new.onTab = handler
        return new
    }
}
