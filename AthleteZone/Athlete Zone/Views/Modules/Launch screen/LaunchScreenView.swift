//
//  LaunchScreenView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    var launchScreenState: LaunchScreenStep

    @State private var scaleAnimation = false
    @State private var startFadeoutAnimation = false
    @State var logoSize: CGFloat = 1

    private let animationTimer = Timer
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()

    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 0.5)
            .repeatForever()
    }

    var body: some View {
        VStack {
            ZStack {
                Image(Picture.background2.rawValue)
                    .resizable()

                Image(Picture.logo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .scaleEffect(scaleAnimation ? 0 : logoSize)
                    .onAppear {
                        withAnimation(self.repeatingAnimation) { self.logoSize = 1.3 }
                    }
            }
            .onReceive(animationTimer) { _ in updateAnimation() }
            .opacity(startFadeoutAnimation ? 0 : 1)
        }
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding(-5)
        .environment(\.colorScheme, .dark)
    }

    private func updateAnimation() {
        switch launchScreenState {
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
        LaunchScreenView(launchScreenState: .secondStep)
    }
}
