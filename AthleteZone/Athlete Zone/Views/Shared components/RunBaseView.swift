//
//  RunBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.01.2024.
//

import SwiftUI

struct RunBaseView<Header: View, Content: View, Footer: View>: View {
    let header: Header
    let content: Content
    let footer: Footer

    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                header
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.08)

                content
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                footer
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geometry.size.height * 0.1)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .top)
            .background(Color(ComponentColor.darkBlue.rawValue))
            .environment(\.colorScheme, .dark)
            .environment(\.footerSize, geometry.size.height * 0.1)
        }
        .ignoresSafeArea(.keyboard, edges: [.bottom])
    }
}

#Preview {
    RunBaseView(
        header: {
            Text("Place header here")
        },
        content: {
            Text("Place content here")
        },
        footer: {}
    )
}
