//
//  ActionView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct ActionView: View {
    let text: LocalizationKey
    let color: ComponentColor
    let backgoundColor: String?
    let image: String?
    let height: CGFloat
    let cornerRadius: CGFloat?

    var body: some View {
        HStack {
            HStack {
                if let image = self.image {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(color.rawValue))
                        .frame(width: 40, height: 40)
                }

                Text(text.localizedKey)
                    .font(.custom("Lato-Black", size: height * 0.5))
                    .foregroundColor(Color(color.rawValue))
                    .bold()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius == nil ? 20 : cornerRadius!)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(backgoundColor == nil ? ComponentColor.darkGrey.rawValue : backgoundColor!))
        )
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 3)
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView(
            text: LocalizationKey.save,
            color: ComponentColor.lightGreen,
            backgoundColor: nil,
            image: Icon.check.rawValue,
            height: 60,
            cornerRadius: 10
        )
    }
}
