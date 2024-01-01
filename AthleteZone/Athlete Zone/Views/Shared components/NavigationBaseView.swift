//
//  NavigationBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.01.2024.
//

import SwiftUI

struct NavigationBaseView<Home: View, Library: View>: View {
    @StateObject var router = ViewRouter.shared
    @StateObject var settingsViewModel = SettingsViewModel()

    let home: Home
    let library: Library

    var currentTab: Tab

    init(
        currentTab: Tab,
        @ViewBuilder home: () -> Home,
        @ViewBuilder library: () -> Library
    ) {
        self.currentTab = currentTab
        self.home = home()
        self.library = library()
    }

    private let minDragTranslationForSwipe: CGFloat = 50
    private let numTabs = Tab.allCases.count

    var body: some View {
        VStack(content: {
            switch currentTab {
            case .home:
                home

            case .library:
                library

            case .setting:
                SettingsScene()
                    .environmentObject(settingsViewModel)
            }
        })
        .highPriorityGesture(DragGesture().onEnded { self.handleSwipe(translation: $0.translation.width) })
    }

    private func handleSwipe(translation: CGFloat) {
        withAnimation {
            if translation > minDragTranslationForSwipe && currentTab.rawValue > 0 {
                router.currentTab = Tab(rawValue: currentTab.rawValue - 1) ?? .home
            } else if translation < -minDragTranslationForSwipe && currentTab.rawValue < numTabs - 1 {
                router.currentTab = Tab(rawValue: currentTab.rawValue + 1) ?? .home
            }
        }
    }
}

#Preview {
    NavigationBaseView(currentTab: .home) {
        Text("Home")
    } library: {
        Text("Library")
    }
}
