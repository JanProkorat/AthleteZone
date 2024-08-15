//
//  TimerRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.07.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimerRunView: View {
    @Bindable var store: StoreOf<TimerRunFeature>

    var body: some View {
        NavigationView {
            TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
                TimerRunTab(store: store)
                    .tag(0)

                HStack(alignment: .center, spacing: 20) {
                    Button(action: {
                        if store.state == .finished {
                            store.send(.timeRemainingChanged(10))
                        }
                        store.send(.pauseTapped)
                        store.send(.selectedTabChanged(0), animation: .default)
                    }, label: {
                        if store.state == .finished {
                            Image(systemName: "repeat.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                                .frame(width: 60, height: 60)
                                .padding(.trailing, 4)
                                .padding(.leading, 6)
                                .padding(.top, 2)
                        } else {
                            Image(store.state == .running || store.state == .preparation ?
                                Icon.actionsPause.rawValue : Icon.start.rawValue)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                                .frame(width: 70, height: 70)
                        }
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
                .tag(1)
            }
            .padding([.leading, .trailing], 5)
            .id("horizontal")
            .sheet(item: $store.activityResult.sending(\.activityResultChanged)) { result in
                ActivityResultView(data: result)
            }
        }
        .navigationTitle(store.state == .paused ? LocalizationKey.paused.localizedKey : LocalizationKey.timer.localizedKey)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    TimerRunView(store: ComposableArchitecture.Store(initialState: TimerRunFeature.State()) {
        TimerRunFeature()
            ._printChanges()
    })
}
