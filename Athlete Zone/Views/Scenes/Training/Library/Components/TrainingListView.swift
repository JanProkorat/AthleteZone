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
                            Label(LocalizedStringKey("Edit"), systemImage: "pencil")
                        })

                        Button(role: .destructive, action: {
                            performAction(onDeleteTab)
                        }, label: {
                            Label(LocalizedStringKey("Delete"), systemImage: "trash")
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
                    HStack {
                        Text("Length")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                            .padding(.leading, 10)

                        Text(training.trainingLength.toFormattedTime())
                            .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                            .padding(.trailing, 30)
                    }
                    .padding([.leading, .trailing])

                    HStack {
                        Text("Workouts")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                            .padding(.leading, 10)

                        Text(training.workoutCount.toFormattedNumber())
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                            .padding(.trailing, 30)
                    }
                    .padding([.leading, .trailing])
                }
                .padding(.bottom)
                .padding([.leading, .trailing], 30)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(Background.work.rawValue))
            )
        }
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
