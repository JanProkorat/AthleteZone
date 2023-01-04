//
//  SelectedMenuItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.11.2022.
//

import SwiftUI

struct SelectedMenuItem: View {
    let height: CGFloat
    let icon: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay(
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                    .frame(width: height, height: height)
            )
            .foregroundColor(Color(ComponentColor.menuItemSelected.rawValue))
            .frame(
                maxWidth: height + 30,
                maxHeight: height + 10,
                alignment: .center
            )
            .cornerRadius(35)
    }
}

struct SelectedMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMenuItem(height: 40, icon: Icons.HomeActive)
    }
}
