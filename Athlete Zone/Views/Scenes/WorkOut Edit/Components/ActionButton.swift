//
//  ActionButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct ActionButton: View {
    let innerComponent: ActionView
    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            if let onTab = self.onTab {
                onTab()
            }
        }, label: {
            innerComponent
        })
        .frame(maxWidth: .infinity)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(
            innerComponent: ActionView(
                text: "Save",
                color: ComponentColor.rounds,
                backgoundColor: nil,
                image: Icons.check.rawValue,
                height: 60,
                cornerRadius: nil
            )
        )
    }
}

extension ActionButton {
    func onTab(_ handler: @escaping () -> Void) -> ActionButton {
        var new = self
        new.onTab = handler
        return new
    }
}
