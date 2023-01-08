//
//  LaunchScreenView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var scaleAnimation = false
    @State private var startFadeoutAnimation = false

    private let animationTimer = Timer
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()

    var body: some View {
        BaseView(
            header: {},
            content: {
                ZStack {
                    background
                    image
                }
                .onReceive(animationTimer) { _ in updateAnimation() }
                .opacity(startFadeoutAnimation ? 0 : 1)
            },
            footer: {}
        )
        .edgesIgnoringSafeArea(.all)
        .padding(-5)
    }

    @ViewBuilder
    private var background: some View {
        Image(Picture.background2.rawValue)
            .resizable()
    }

    @ViewBuilder
    private var image: some View {
        Image(Picture.logo.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 400, height: 400)
            .scaleEffect(scaleAnimation ? 0 : 1)
    }

    private func updateAnimation() {
        switch launchScreenState.state {
        case .firstStep:
            break

        case .secondStep:
            if scaleAnimation == false {
                withAnimation(.linear) {
                    self.scaleAnimation = true
                    startFadeoutAnimation = true
                }
            }

        case .finished:
            break
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenStateManager())
    }
}
