//
//  ActivitySelect.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.12.2022.
//

import SwiftUI

struct ActivitySelect: View {
    let image: String
    let color: String
    let activity: ActivityType
    let interval: Int
    let type: LabelType
    let height: CGFloat

    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            self.performAction(onTab)
        }, label: {
            HStack {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: height - 5, maxHeight: height - 5)
                        .padding(.leading, 10)
                        .padding([.top, .bottom], 2)
                        .foregroundColor(Color(color))

                    Text(LocalizedStringKey(activity.rawValue))
                        .font(.custom("Lato-Black", size: 20))
                        .bold()
                        .foregroundColor(Color(color))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(interval.toFormattedValue(type: type))
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .foregroundColor(Color(color))
                    .padding(.trailing)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(maxHeight: 70)
                        .foregroundColor(Color("\(color)_background"))
                }
            )
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.bottom, 3)

        })
        .frame(maxWidth: .infinity)
    }
}

struct ActivitySelect_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySelect(image: "forward.circle", color: ComponentColor.work.rawValue,
                       activity: .work, interval: 40, type: .time, height: 50)
    }
}

extension ActivitySelect {
    func onTab(_ handler: @escaping () -> Void) -> ActivitySelect {
        var new = self
        new.onTab = handler
        return new
    }
}
