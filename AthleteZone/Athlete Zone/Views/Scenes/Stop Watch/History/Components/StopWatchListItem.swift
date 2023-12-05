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

    init(activity: StopWatch) {
        self.activity = activity
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TitleText(text: activity.name == nil || activity.name!.isEmpty ? "Activity" : activity.name!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Button {
                    showingAlert.toggle()
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .customAlert("", isPresented: $showingAlert) {
                VStack {
                    Text(LocalizationKey.enterNameLabel.localizedKey)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Divider()
                }
                CustomTextField(placeholder: LocalizationKey.namePlaceholder.localizedKey, text: $name)
                    .padding([.leading, .trailing, .top])
            } actions: {
                MultiButton {
                    Button {
                        performAction(onSubmitTab, value: name)
                        self.showingAlert = false
                    } label: {
                        Text(LocalizationKey.save.localizedKey)
                    }
                    Button {
                        self.showingAlert = false
                    } label: {
                        Text(LocalizationKey.cancel.localizedKey)
                            .foregroundStyle(.red)
                    }
                }
            }
            .environment(\.customAlertConfiguration, .create { configuration in
                configuration.background = .blurEffect(.dark)
                configuration.padding = EdgeInsets()
                configuration.alert = .create { alert in
                    alert.background = .color(.darkBlue)
                    alert.cornerRadius = 10
                    alert.padding = EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
                    alert.alignment = .center
                    alert.contentFont = .subheadline
                    alert.alignment = .leading
                    alert.minWidth = 350
                }
            })

            VStack(spacing: 7) {
                descriptionView(
                    property: LocalizationKey.start.localizedKey,
                    value: activity.startDate.toFormattedString(),
                    color: ComponentColor.lightPink
                )

                descriptionView(
                    property: LocalizationKey.end.localizedKey,
                    value: activity.endDate.toFormattedString(),
                    color: ComponentColor.lightYellow
                )
            }
            .padding(.bottom)
            .padding([.leading, .trailing], 30)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
        )
    }

    @ViewBuilder
    func descriptionView(property: LocalizedStringKey, value: String, color: ComponentColor) -> some View {
        HStack {
            Text(property)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .scaledToFill()
            Text(":")
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .padding(.leading, -7)
            Text(value)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
        }
        .padding([.leading, .trailing])
    }
}

extension StopWatchListItem {
    func onSubmitTab(_ handler: @escaping (_ name: String) -> Void) -> StopWatchListItem {
        var new = self
        new.onSubmitTab = handler
        return new
    }
}

#Preview {
    StopWatchListItem(activity: StopWatch())
}
