//
//  ExerciseContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutContent: View {
    var work = 0
    var rest = 0
    var series = 0
    var rounds = 0
    var reset = 0

    var onTab: ((_ type: ActivityType) -> Void)?
    var onStartTab: (() -> Void)?

    private var timeOverview: Int {
        ((work * series) + (rest * (series - 1)) + reset) * rounds
    }

    init(_ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    var buttons = [
        WorkOutButtonConfig(id: .work, image: Icons.Play, color: .work, type: .time),
        WorkOutButtonConfig(id: .rest, image: Icons.Pause, color: .rest, type: .time),
        WorkOutButtonConfig(id: .series, image: Icons.Forward, color: .series, type: .number),
        WorkOutButtonConfig(id: .rounds, image: Icons.Repeat, color: .rounds, type: .number),
        WorkOutButtonConfig(id: .reset, image: Icons.Time, color: .reset, type: .time)
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
                            interval: getInterval(button.id),
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
                            text: timeOverview.toFormattedValue(type: .time),
                            size: geo.size.height * 0.2
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)
                    Button {
                        performAction(onStartTab)
                    } label: {
                        Image(Icons.Start)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.action.rawValue))
                            .frame(maxWidth: geo.size.height * 0.3, maxHeight: geo.size.height * 0.3)
                    }
                }
                .frame(height: geo.size.height * 0.5)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WorkOutContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContent(40, 60, 3, 2, 60)
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension WorkOutContent {
    func onTab(action: @escaping ((_ type: ActivityType) -> Void)) -> WorkOutContent {
        var new = self
        new.onTab = action
        return new
    }

    func onStartTab(action: @escaping (() -> Void)) -> WorkOutContent {
        var new = self
        new.onStartTab = action
        return new
    }

    func getInterval(_ type: ActivityType) -> Int {
        switch type {
        case .work:
            return work

        case .rest:
            return rest

        case .series:
            return series

        case .rounds:
            return rounds

        case .reset:
            return reset
        }
    }
}
