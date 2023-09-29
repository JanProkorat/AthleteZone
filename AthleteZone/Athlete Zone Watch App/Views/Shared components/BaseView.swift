//
//  BaseView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct BaseView<Content: View>: View {
    let content: Content
    var title: LocalizedStringKey

    init(title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 7)
                .font(.title3)
                .foregroundColor(Color(ComponentColor.buttonGreen.rawValue))

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding([.leading, .trailing], 5)
        }
        .frame(maxWidth: .infinity)
        .background(Color(Background.background.rawValue))
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(title: "string") {
            Text("ahoj")
        }
    }
}
