//
//  ExerciseEditContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditContent: View {
    @EnvironmentObject var viewModel: WorkOutEditViewModel

    var onNameChange: ((_ value: String) -> Void)?
    var onEditTab: ((_ value: ActivityType) -> Void)?

    var buttons = [
        WorkOutButtonConfig(id: .work, image: Icons.play.rawValue, color: .work, type: .time),
        WorkOutButtonConfig(id: .rest, image: Icons.pause.rawValue, color: .rest, type: .time),
        WorkOutButtonConfig(id: .series, image: Icons.forward.rawValue, color: .series, type: .number),
        WorkOutButtonConfig(id: .rounds, image: Icons.repeatIcon.rawValue, color: .rounds, type: .number),
        WorkOutButtonConfig(id: .reset, image: Icons.time.rawValue, color: .reset, type: .time)
    ]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    EditField(label: "Name", labelSize: 23, color: ComponentColor.mainText) {
                        TextInput(text: $viewModel.name)
                    }
                    .padding([.top, .bottom])
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .roundedBackground(cornerRadius: 20)

                VStack(alignment: .center, spacing: 3) {
                    ForEach(buttons, id: \.id) { button in
                        ActivitySelect(
                            image: button.image,
                            color: button.color.rawValue,
                            activity: button.id,
                            interval: getProperty(for: button.id),
                            type: button.type,
                            height: geo.size.height * 0.45 * 0.2
                        )
                        .onTab {
                            performAction(self.onEditTab, value: button.id)
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5, alignment: .top)
                .frame(maxWidth: .infinity)
                .padding(.top)

                CounterText(
                    text: viewModel.timeOverview.toFormattedTime(),
                    size: geo.size.height * 0.12
                )
                .padding(.top)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    func getProperty(for activityType: ActivityType) -> Int {
        switch activityType {
        case .work:
            return viewModel.work

        case .rest:
            return viewModel.rest

        case .series:
            return viewModel.series

        case .rounds:
            return viewModel.rounds

        case .reset:
            return viewModel.reset
        }
    }
}

struct ExerciseEditContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditContent()
            .environmentObject(WorkOutEditViewModel(workout: WorkOut()))
    }
}

extension WorkOutEditContent {
    func onNameChange(_ handler: @escaping (_ value: String) -> Void) -> WorkOutEditContent {
        var new = self
        new.onNameChange = handler
        return new
    }

    func onEditTab(_ handler: @escaping (_ value: ActivityType) -> Void) -> WorkOutEditContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}

struct TextInputStyle: TextFieldStyle {
    let height: CGFloat

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(Background.background.rawValue))
                    .frame(height: height * 0.7)
            ).padding()
    }
}
