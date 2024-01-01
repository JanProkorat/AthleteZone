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
                HistoryContent(
                    library: viewModel.library,
                    searchText: $viewModel.searchText,
                    sortOrder: $viewModel.sortOrder,
                    sortBy: $viewModel.sortBy
                )
                .onEditSaveTab { activityInfo in
                    viewModel.updateActivity(activityInfo.id, activityInfo.name)
                }
                .onDeleteTab { activity in
                    viewModel.deleteActivity(activity)
                }
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
