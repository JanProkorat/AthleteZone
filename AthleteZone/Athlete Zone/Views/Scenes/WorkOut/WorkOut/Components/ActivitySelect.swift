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
                    Image(systemName: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: height * 0.7, maxHeight: height * 0.7)
                        .padding(.leading, 10)
                        .padding([.top, .bottom], 2)
                        .foregroundColor(Color(color))

                    Text(LocalizedStringKey(activity.rawValue))
                        .font(.title3)
                        .foregroundColor(Color(color))
                        .padding(.leading, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    if interval == 0 {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                            .padding(.trailing)
                    }

                    Text(interval.toFormattedValue(type: type))
                        .font(.headline)
                        .bold()
                        .foregroundColor(interval == 0 ? .red : Color(color))
                        .padding(.trailing)
                }
                .animation(.default, value: interval)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: height)
                        .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
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
        ActivitySelect(image: "forward.circle", color: ComponentColor.lightPink.rawValue,
                       activity: .work, interval: 0, type: .time, height: 50)
    }
}

extension ActivitySelect {
    func onTab(_ handler: @escaping () -> Void) -> ActivitySelect {
        var new = self
        new.onTab = handler
        return new
    }
}
