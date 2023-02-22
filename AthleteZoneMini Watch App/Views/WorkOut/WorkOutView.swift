//
//  WorkOutView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct WorkOutView: View {
    @StateObject var workFlowViewModel: WorkFlowViewModel
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedTab = 0

    private let workOutContent = WorkOutContent()

    var body: some View {
        TabView(selection: $selectedTab) {
            workOutContent
                .tag(0)

            WorkOutActions()
                .onTab { selectedTab = 0 }
                .tag(1)
        }
        .environmentObject(workFlowViewModel)
        .onAppear {
            if let workout = viewModel.selectedWorkOut {
                workFlowViewModel.createWorkFlow(workOut: workout)
            }
        }
        .onChange(of: workFlowViewModel.state) { newValue in
            if newValue == .quit {
                viewModel.selectedWorkOut = nil
            }
        }
    }
}

struct WorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutView(workFlowViewModel: WorkFlowViewModel())
            .environmentObject(ViewModel())
    }
}
