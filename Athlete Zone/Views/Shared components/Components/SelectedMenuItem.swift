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
    let text: LocalizedStringKey

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay(
                HStack(alignment: .center, spacing: 1) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(Colors.DarkBlue))
                        .frame(width: 20, height: 20)
                    Text(text)
                        .padding(.leading, 5)
                        .foregroundColor(Color(Colors.DarkBlue))
                }
            )
            .foregroundColor(Color(Colors.MenuItemSelected))
            .frame(width: .infinity,
                   height: height,
                   alignment: .center)
            .cornerRadius(35)
    }
}

struct SelectedMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMenuItem(height: 40, icon: Icons.HomeActive, text: "Home")
    }
}
