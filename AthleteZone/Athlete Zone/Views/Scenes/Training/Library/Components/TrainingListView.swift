//
//  TrainingListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingListView: View {
    let training: Training

    var onInfoTab: (() -> Void)?
    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?

    var body: some View {
        LibraryItemBaseView(name: training.name) {
            VStack(spacing: 7) {
                descriptionView(
                    property: LocalizationKey.length.localizedKey,
                    value: training.trainingLength.toFormattedTime(),
                    color: ComponentColor.lightPink
                )

                descriptionView(
                    property: LocalizationKey.workouts.localizedKey,
                    value: training.workoutCount.toFormattedNumber(),
                    color: ComponentColor.lightYellow
                )

                descriptionView(
                    property: LocalizationKey.createdDate.localizedKey,
                    value: training.formattedCreatedDate,
                    color: ComponentColor.braun
                )
            }
            .padding(.top, -10)
            .padding([.leading, .trailing], 30)
        }
        .onEditTab { performAction(onEditTab) }
        .onDeleteTab { performAction(onDeleteTab) }
        .onInfoTab { performAction(onInfoTab) }
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
        }
    }
}

struct TrainingListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingListView(training: Training())
    }
}

extension TrainingListView {
    func onInfoTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onInfoTab = handler
        return new
    }

    func onEditTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}
