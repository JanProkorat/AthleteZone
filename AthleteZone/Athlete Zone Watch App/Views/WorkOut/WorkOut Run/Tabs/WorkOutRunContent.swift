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
                TabView {
                    VStack {
                        Description(
                            title: "Round \(flow.round)/\(flow.totalRounds)",
                            color: ComponentColor.lightGreen
                        )

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
                            .foregroundStyle(.accent)

                        //                        TimelineView(.periodic(from: Date(), by: 0.1)) { _ in
                        Text(flow.interval.toFormattedTime())
                            .font(.largeTitle)
                            .scaledToFill()
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .padding(.top)
                            .foregroundColor(Color(flow.color.rawValue))
                        //                        }
                    }
                    .padding(.top, -25)

                    VStack(alignment: .leading) {
                        Text(viewModel.timeElapsed)
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Text(String(format: "%.0f", viewModel.activeEnergy))
                                .font(.title)
                                .foregroundColor(.white)

                            VStack(alignment: .leading) {
                                Text("Aktivní")
                                    .font(.footnote)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)

                                Text("kcal")
                                    .font(.footnote)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading)
                        }

                        HStack {
                            Text(String(format: "%.0f", viewModel.baseEnergy))
                                .font(.title)
                                .foregroundColor(.white)

                            VStack(alignment: .leading) {
                                Text("Celkem")
                                    .font(.footnote)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)

                                Text("kcal")
                                    .font(.footnote)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading)
                        }

                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text(String(format: "%.0f", viewModel.heartRate))
                                .font(.title2)
                                .foregroundColor(.white)

                            Text("BPM")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading)
                }
                .tabViewStyle(.verticalPage)
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
