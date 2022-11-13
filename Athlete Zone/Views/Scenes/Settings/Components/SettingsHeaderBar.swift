//
//  SettingsHeaderBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct SettingsHeaderBar: View {
    var body: some View {
        Text("Settings")
            .font(.custom("Lato-Black", size: 40))
            .bold()
            .foregroundColor(Color(Colors.MainText))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingsHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHeaderBar()
    }
}
