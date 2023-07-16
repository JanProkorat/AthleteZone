//
//  WorkOutContent.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct WorkOutContent: View {
    @EnvironmentObject var workFlowViewModel: WorkFlowViewModel
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        if let flow = workFlowViewModel.selectedFlow {
            BaseView(title: LocalizedStringKey(viewModel.selectedWorkOut?.name ?? "")) {
                VStack {
                    Description(
                        title: "Round \(flow.round)/\(flow.totalRounds)",
                        color: ComponentColor.lightGreen
                    )
                    .padding(.top)
                    Description(
                        title: "Exercise \(flow.serie)/\(flow.totalSeries)",
                        color: ComponentColor.lightBlue
                    )

                    Text(LocalizedStringKey(flow.type.rawValue))
                        .font(.headline)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

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

                    Spacer()
                }
                .edgesIgnoringSafeArea([.top, .bottom])
            }
            .onAppear {
                if workFlowViewModel.state == .ready {
                    workFlowViewModel.setState(.running)
                }
            }
        }
    }
}

struct WorkOutContent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkFlowViewModel()
        viewModel.createWorkFlow("Title", 30, 60, 2, 1, 120)
        return WorkOutContent()
            .environmentObject(viewModel)
            .environmentObject(ViewModel())
    }
}
