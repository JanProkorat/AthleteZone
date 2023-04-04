//
//  ProfileHeaderBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ProfileHeaderBar: View {
    var body: some View {
        Text("User Profile")
            .font(.custom("Lato-Black", size: 40))
            .bold()
            .foregroundColor(Color(ComponentColor.mainText.rawValue))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProfileHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderBar()
    }
}
