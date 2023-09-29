//
//  WorkOutView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct WorkOutRunView: View {
    @EnvironmentObject var workFlowViewModel: WatchWorkOutRunViewModel
    @State private var selectedTab = 1

    private let workOutContent = WorkOutRunContent()

    var body: some View {
        TabView(selection: $selectedTab) {
            HealthView()
                .tag(0)

            workOutContent
                .tag(1)

            WorkOutActions()
                .onTab { selectedTab = 0 }
                .tag(2)
        }
        .environmentObject(workFlowViewModel)
    }
}

struct WorkOutRunView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunView()
            .environmentObject(WatchWorkOutRunViewModel())
    }
}
