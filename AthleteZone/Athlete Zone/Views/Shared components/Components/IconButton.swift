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

    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            self.performAction(onTab)
        }, label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(color.rawValue))
        })
        .frame(width: width, height: height)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(
            id: "arrowDown",
            image: Icons.arrowDown.rawValue,
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
