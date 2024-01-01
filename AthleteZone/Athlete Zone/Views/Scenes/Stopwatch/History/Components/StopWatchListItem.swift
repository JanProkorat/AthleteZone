//
//  StopWatchListItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchListItem: View {
    var activity: StopWatch

    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?
    var onSelectTab: (() -> Void)?

    var body: some View {
        Button(action: {
            performAction(onSelectTab)
        }, label: {
            LibraryItemBaseView(name: activity.name, infoEnabled: false) {
                VStack(spacing: 7) {
                    DescriptionView(
                        property: LocalizationKey.start.localizedKey,
                        value: activity.startDate.toFormattedString(),
                        color: ComponentColor.lightPink
                    )

                    DescriptionView(
                        property: LocalizationKey.end.localizedKey,
                        value: activity.endDate.toFormattedString(),
                        color: ComponentColor.lightYellow
                    )
                }
                .padding(.top, -10)
            }
            .onDeleteTab { performAction(onDeleteTab) }
            .onEditTab { performAction(onEditTab) }
        })
        .padding(.bottom, 5)
        .background(Color(ComponentColor.darkBlue.rawValue))
    }
}

extension StopWatchListItem {
    func onEditTab(_ handler: @escaping () -> Void) -> StopWatchListItem {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> StopWatchListItem {
        var new = self
        new.onDeleteTab = handler
        return new
    }

    func onSelectTab(_ handler: @escaping () -> Void) -> StopWatchListItem {
        var new = self
        new.onSelectTab = handler
        return new
    }
}

#Preview {
    StopWatchListItem(activity: StopWatch())
}
