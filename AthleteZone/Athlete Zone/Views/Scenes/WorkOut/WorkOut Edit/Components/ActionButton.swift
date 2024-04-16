//
//  ActionButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct ActionButton<Content: View>: View {
    let content: Content
    var onTab: (() -> Void)?

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        Button(action: {
            if let onTab = self.onTab {
                onTab()
            }
        }, label: {
            content
        })
        .frame(maxWidth: .infinity)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton {
            ActionView(
                text: LocalizationKey.save,
                color: ComponentColor.lightGreen,
                backgoundColor: nil,
                image: Icon.check.rawValue,
                height: 60,
                cornerRadius: nil
            )
        }
    }
}

extension ActionButton {
    func onTab(_ handler: @escaping () -> Void) -> ActionButton {
        var new = self
        new.onTab = handler
        return new
    }
}
