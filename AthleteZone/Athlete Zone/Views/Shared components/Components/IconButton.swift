//
//  IconButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.11.2022.
//

import SwiftUI

struct IconButton: View, Identifiable {
    let id: String

    let image: String
    let color: ComponentColor
    let width: CGFloat
    let height: CGFloat
    var reversed = false
    var hasSystemIcon = false

    init(id: String, image: String, color: ComponentColor, width: CGFloat, height: CGFloat) {
        self.id = id
        self.image = image
        self.color = color
        self.width = width
        self.height = height
    }

    init(id: String, image: String, color: ComponentColor, width: CGFloat, height: CGFloat, reversed: Bool) {
        self.id = id
        self.image = image
        self.color = color
        self.width = width
        self.height = height
        self.reversed = reversed
    }

    init(id: String, color: ComponentColor, width: CGFloat, height: CGFloat, hasSystemIcon: Bool) {
        self.id = id
        self.image = ""
        self.color = color
        self.width = width
        self.height = height
        self.hasSystemIcon = hasSystemIcon
    }

    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            self.performAction(onTab)
        }, label: {
            if !hasSystemIcon {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(color.rawValue))
                    .scaleEffect(x: reversed ? -1 : 1, y: 1)
            } else {
                Image(systemName: id)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(color.rawValue))
            }

        })
        .frame(width: width, height: height)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(
            id: "arrowDown",
            image: Icon.arrowDown.rawValue,
            color: ComponentColor.mainText,
            width: 50,
            height: 45
        )
    }
}

extension IconButton {
    func onTab(_ handler: @escaping () -> Void) -> IconButton {
        var new = self
        new.onTab = handler
        return new
    }
}
