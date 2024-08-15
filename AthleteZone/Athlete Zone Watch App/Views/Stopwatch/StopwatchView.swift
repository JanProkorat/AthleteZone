//
//  StopwatchView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 21.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct StopwatchView: View {
    @Bindable var store: StoreOf<StopwatchFeature>

    var body: some View {
        VStack {
            NavigationLink(state: ContentFeature.Path.State.stopwatchRun(StopwatchRunFeature.State())) {
                Image(Icon.start.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.buttonGreen.rawValue))
                    .frame(width: 120, height: 120)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    StopwatchView(store: ComposableArchitecture.Store(initialState: StopwatchFeature.State()) {
        StopwatchFeature()
            ._printChanges()
    })
}
