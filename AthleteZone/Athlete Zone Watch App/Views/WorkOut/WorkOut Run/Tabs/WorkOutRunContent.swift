//
//  WorkOutContent.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct WorkOutRunContent: View {
    @EnvironmentObject var viewModel: WatchWorkOutRunViewModel

    var body: some View {
        if let flow = viewModel.selectedFlow {
            BaseView(title: LocalizedStringKey(viewModel.state == .paused ? "Paused" : viewModel.workoutName)) {
                VStack {
                    Description(
                        title: "Round \(flow.round)/\(flow.totalRounds)",
                        color: ComponentColor.lightGreen
                    )
                    .padding(.top)

                    HStack {
                        Button {
                            viewModel.selectedFlowIndex -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 15)
                        .disabled(viewModel.isFirstRunning)

                        Description(
                            title: "Exercise \(flow.serie)/\(flow.totalSeries)",
                            color: ComponentColor.lightBlue
                        )

                        Button {
                            viewModel.selectedFlowIndex += 1
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 15)
                        .disabled(viewModel.isLastRunning)
                    }
                    .roundedBackground(cornerRadius: 10, color: Color(Background.listItemBackground.rawValue))
                    .padding(.top, 1)

                    Text(LocalizedStringKey(flow.type.rawValue))
                        .font(.headline)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Button {
                        self.viewModel.state = self.viewModel.state == .running ? .paused : .running
                    } label: {
                        TimelineView(.periodic(from: Date(), by: 0.1)) { _ in
                            Text(flow.interval.toFormattedTime())
                                .font(.largeTitle)
                                .scaledToFill()
                                .scaledToFit()
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .padding(.top)
                                .foregroundColor(Color(flow.color.rawValue))
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .edgesIgnoringSafeArea([.top, .bottom])
            }
            .onAppear {
                if viewModel.state == .ready {
                    viewModel.setState(.running)
                }
            }
        }
    }
}

struct WorkOutRunContent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WatchWorkOutRunViewModel()
        viewModel.setupViewModel(workout: WorkOutDto(
            id: "1",
            name: "Prvni",
            work: 2,
            rest: 2,
            series: 2,
            rounds: 2,
            reset: 30,
            createdDate: Date(),
            workoutLength: 50
        ))
        return WorkOutRunContent()
            .environmentObject(viewModel)
    }
}
