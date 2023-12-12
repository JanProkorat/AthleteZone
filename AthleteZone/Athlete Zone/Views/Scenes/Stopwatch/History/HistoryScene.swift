//
//  HistoryScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct HistoryScene: View {
    @EnvironmentObject var viewModel: HistoryViewModel

    var body: some View {
        BaseView(
            header: {
                HStack(alignment: .center) {
                    SectionSwitch()
                    TitleText(text: LocalizationKey.history.rawValue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            },
            content: {
                HistoryContent()
                    .environmentObject(viewModel)
            },
            footer: {
                MenuBar(activeTab: viewModel.router.currentTab)
                    .onRouteTab { viewModel.router.currentTab = $0 }
            }
        )
    }
}

#Preview {
    HistoryScene()
        .environmentObject(HistoryViewModel())
}
