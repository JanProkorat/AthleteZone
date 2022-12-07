//
//  ActivityPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct ActivityPicker: View {
    let title: String
    let color: String
    let backgroundColor: String

    let picker: AnyView

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(Colors.DarkBlue), lineWidth: 3)
                    .foregroundColor(Color(backgroundColor))
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(backgroundColor))
                Text(title)
                    .font(.custom("Lato-Black", size: 40))
                    .bold()
                    .foregroundColor(Color(color))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 30)
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 80)

            picker
                .frame(maxHeight: .infinity)
                .padding(.top, 20)
        }
        .frame(maxHeight: .infinity)
        .background(Color(Backgrounds.Background))
        .presentationDetents([.medium])
    }
}

struct ActivityPicker_Previews: PreviewProvider {
    static var previews: some View {
        ActivityPicker(
            title: "Work",
            color: Colors.Work,
            backgroundColor: Backgrounds.WorkBackground,
            picker: AnyView(TimePicker(textColor: Colors.Work, interval: 40))
        )
    }
}
