//
//  TrainingListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingListView: View {
    let training: Training

    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?

    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack(alignment: .center) {
                    TitleText(text: training.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    Menu {
                        Button(action: {
                            performAction(onEditTab)
                        }, label: {
                            Label(LocalizationKey.edit.localizedKey, systemImage: "pencil")
                        })

                        Button(role: .destructive, action: {
                            performAction(onDeleteTab)
                        }, label: {
                            Label(LocalizationKey.delete.localizedKey, systemImage: "trash")
                        })
                    } label: {
                        Image(Icons.menu.rawValue)
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                            .frame(width: 40, height: 34)
                            .padding(.trailing, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)

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
                .padding(.bottom)
                .padding([.leading, .trailing], 30)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            )
        }
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

struct TrainingListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingListView(training: Training())
    }
}

extension TrainingListView {
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
