//
//  StopWatchListItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import CustomAlert
import SwiftUI

struct StopWatchListItem: View {
    var activity: StopWatch

    @State var showingAlert = false
    @State var name = ""

    var onSubmitTab: ((_ name: String) -> Void)?
    var onDeleteTab: (() -> Void)?

    init(activity: StopWatch) {
        self.activity = activity
        _name = State(wrappedValue: activity.name)
    }

    var body: some View {
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
        .onEditTab { showingAlert.toggle() }
        .customAlert("", isPresented: $showingAlert) {
            VStack {
                Text(LocalizationKey.enterNameLabel.localizedKey)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
            }
            CustomTextField(
                placeholder: LocalizationKey.namePlaceholder.localizedKey,
                text: $name
            )
            .padding([.leading, .trailing, .top])
        } actions: {
            MultiButton {
                Button {
                    performAction(onSubmitTab, value: name)
                } label: {
                    Text(LocalizationKey.save.localizedKey)
                }

                Button {} label: {
                    Text(LocalizationKey.cancel.localizedKey)
                }
            }
        }
        .addAlertConfiguration()
    }
}

extension StopWatchListItem {
    func onSubmitTab(_ handler: @escaping (_ name: String) -> Void) -> StopWatchListItem {
        var new = self
        new.onSubmitTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> StopWatchListItem {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}

#Preview {
    StopWatchListItem(activity: StopWatch())
}
