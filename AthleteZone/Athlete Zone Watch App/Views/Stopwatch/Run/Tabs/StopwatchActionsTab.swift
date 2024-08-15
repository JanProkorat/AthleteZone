//
//  StopwatchActionsTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 05.07.2024.
//

import ComposableArchitecture
import SwiftUI

struct StopwatchActionsTab: View {
    @Bindable var store: StoreOf<StopwatchRunFeature>

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                store.send(.pauseTapped)
                store.send(.selectedTabChanged(1), animation: .default)
            }, label: {
                Image(store.state == .running || store.state == .preparation ? Icon.actionsPause.rawValue : Icon.start.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                    .frame(width: 70, height: 70)
            })
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(x: 1.22, y: 1.22, anchor: .center)

            Button(action: {
                store.send(.quitTapped)
            }, label: {
                Image(Icon.stop.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.braun.rawValue))
                    .frame(width: 70, height: 70)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 4)
        }
    }
}

#Preview {
    StopwatchActionsTab(store: ComposableArchitecture.Store(initialState: StopwatchRunFeature.State()) {
        StopwatchRunFeature()
            ._printChanges()
    })
}
