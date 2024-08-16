//
//  WorkoutRunActionsTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 18.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct ActionsView: View {
    var isFirstRunning: Bool
    var isLastRunning: Bool
    var state: WorkFlowState

    var onBackTap: (() -> Void)?
    var onForwardTap: (() -> Void)?
    var onPauseTap: (() -> Void)?
    var onQuitTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 20) {
                Button(action: {
                    performAction(onBackTap)
                }, label: {
                    Image(Icon.actionsForward.rawValue)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                        .frame(width: 70, height: 70)
                })
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .disabled(isFirstRunning)

                Button(action: {
                    performAction(onForwardTap)
                }, label: {
                    Image(Icon.actionsForward.rawValue)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                        .frame(width: 70, height: 70)
                })
                .buttonStyle(PlainButtonStyle())
                .disabled(isLastRunning)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top)

            HStack(alignment: .center, spacing: 20) {
                Button(action: {
                    performAction(onPauseTap)

                }, label: {
                    if state == .finished {
                        Image(systemName: "repeat.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                            .frame(width: 60, height: 60)
                            .padding(.trailing, 4)
                            .padding(.leading, 6)
                            .padding(.top, 2)
                    } else {
                        Image(state == .running || state == .preparation ?
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
                    performAction(onQuitTap)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 15)
    }
}

extension ActionsView {
    func onBackTap(_ handler: @escaping () -> Void) -> ActionsView {
        var new = self
        new.onBackTap = handler
        return new
    }

    func onForwardTap(_ handler: @escaping () -> Void) -> ActionsView {
        var new = self
        new.onForwardTap = handler
        return new
    }

    func onPauseTap(_ handler: @escaping () -> Void) -> ActionsView {
        var new = self
        new.onPauseTap = handler
        return new
    }

    func onQuitTap(_ handler: @escaping () -> Void) -> ActionsView {
        var new = self
        new.onQuitTap = handler
        return new
    }
}

#Preview {
    ActionsView(isFirstRunning: true, isLastRunning: false, state: .paused)
}
