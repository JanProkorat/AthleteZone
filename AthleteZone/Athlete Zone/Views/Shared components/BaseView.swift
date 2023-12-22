//
//  BaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.12.2022.
//

import SwiftUI

struct BaseView<Header: View, Content: View, Footer: View>: View {
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
                    .environment(\.contentSize, geometry.size)

                footer
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geometry.size.height * 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(ComponentColor.darkBlue.rawValue))
            .environment(\.colorScheme, .dark)
            .environment(\.footerSize, geometry.size.height * 0.1)
        }
        .ignoresSafeArea(.keyboard, edges: [.bottom])
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(
            header: {
                Text("Place header here")
            },
            content: {
                Text("Place content here")
            },
            footer: {}
        )
    }
}

extension EnvironmentValues {
    var contentSize: CGSize {
        get { self[ContentSizeKey.self] }
        set { self[ContentSizeKey.self] = newValue }
    }

    var footerSize: CGFloat {
        get { self[FooterSizeKey.self] }
        set { self[FooterSizeKey.self] = newValue }
    }
}

struct ContentSizeKey: EnvironmentKey {
    static var defaultValue: CGSize { .zero }
}

struct FooterSizeKey: EnvironmentKey {
    static var defaultValue: CGFloat { .zero }
}
