//
//  ListViewText.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.11.2022.
//

import SwiftUI

struct ListViewText: View {
    let text: String
    let color: ComponentColor

    var body: some View {
        Text(text)
            .font(.custom("Lato-Black", size: 20))
            .foregroundColor(Color(color.rawValue))
    }
}

struct ListViewText_Previews: PreviewProvider {
    static var previews: some View {
        ListViewText(text: "Work", color: ComponentColor.work)
    }
}
