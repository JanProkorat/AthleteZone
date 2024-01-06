//
//  DetailBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.01.2024.
//

import SwiftUI

struct DetailBaseView<Content: View>: View {
    let content: Content
    var title: String?
    var localizetTitle: LocalizedStringKey?
    var color: ComponentColor

    var onCloseTab: (() -> Void)?

    init(title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        color = .mainText
    }

    init(title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.content = content()
        localizetTitle = title
        color = .mainText
    }

    init(title: String, color: ComponentColor, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.color = color
    }

    init(title: LocalizedStringKey, color: ComponentColor, @ViewBuilder content: () -> Content) {
        self.content = content()
        localizetTitle = title
        self.color = color
    }

    var body: some View {
        VStack {
            HStack {
                if let stringTitle = title {
                    Text(stringTitle)
                        .font(.title)
                        .foregroundColor(Color(color.rawValue))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding([.top, .bottom])
                        .roundedBackground(cornerRadius: 20, color: .darkBlue, border: ComponentColor.darkGrey, borderWidth: 3)
                        .padding([.leading, .trailing])
                } else {
                    Text(localizetTitle!)
                        .font(.title)
                        .foregroundColor(Color(color.rawValue))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding([.top, .bottom])
                        .roundedBackground(cornerRadius: 20, color: .darkBlue, border: ComponentColor.darkGrey, borderWidth: 3)
                        .padding([.leading, .trailing])
                }
            }
            .padding(.top)

            VStack {
                content
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])

            Button(action: {
                performAction(onCloseTab)
            }, label: {
                Text(LocalizationKey.close.localizedKey)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 10)
                    .foregroundStyle(Color(color.rawValue))
            })
            .roundedBackground(cornerRadius: 20, color: ComponentColor.darkGrey)
            .padding([.leading, .trailing])
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    DetailBaseView(title: "title") {
        Text("content here")
    }
}

extension DetailBaseView {
    func onCloseTab(_ handler: @escaping () -> Void) -> DetailBaseView {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
