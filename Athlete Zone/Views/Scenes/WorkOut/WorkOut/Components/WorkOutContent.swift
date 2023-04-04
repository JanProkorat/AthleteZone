//
//  ExerciseContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutContent: View {
    @EnvironmentObject var viewModel: WorkOutViewModel

    var onTab: ((_ type: ActivityType) -> Void)?
    var onStartTab: (() -> Void)?

    var buttons = [
        WorkOutButtonConfig(id: .work, image: Icons.play.rawValue, color: .work, type: .time),
        WorkOutButtonConfig(id: .rest, image: Icons.pause.rawValue, color: .rest, type: .time),
        WorkOutButtonConfig(id: .series, image: Icons.forward.rawValue, color: .series, type: .number),
        WorkOutButtonConfig(id: .rounds, image: Icons.repeatIcon.rawValue, color: .rounds, type: .number),
        WorkOutButtonConfig(id: .reset, image: Icons.time.rawValue, color: .reset, type: .time)
    ]

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(alignment: .center, spacing: 3) {
                    ForEach(buttons, id: \.id) { button in
                        ActivitySelect(
                            image: button.image,
                            color: button.color.rawValue,
                            activity: button.id,
                            interval: viewModel.getProperty(for: button.id),
                            type: button.type,
                            height: geo.size.height * 0.45 * 0.2
                        )
                        .onTab {
                            performAction(self.onTab, value: button.id)
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5, alignment: .top)
                .frame(maxWidth: .infinity)

                VStack(alignment: .center, spacing: 3) {
                    HStack(alignment: .center) {
                        CounterText(
                            text: viewModel.timeOverview.toFormattedTime(),
                            size: geo.size.height * 0.2
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)
                    Button {
                        performAction(onStartTab)
                    } label: {
                        Image(Icons.start.rawValue)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.action.rawValue))
                            .frame(maxWidth: geo.size.height * 0.3, maxHeight: geo.size.height * 0.3)
                    }
                }
                .frame(height: geo.size.height * 0.47)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WorkOutContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContent()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension WorkOutContent {
    func onTab(action: @escaping (_ type: ActivityType) -> Void) -> WorkOutContent {
        var new = self
        new.onTab = action
        return new
    }

    func onStartTab(action: @escaping () -> Void) -> WorkOutContent {
        var new = self
        new.onStartTab = action
        return new
    }
}
