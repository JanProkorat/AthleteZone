//
//  LaunchScreenView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.02.2023.
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
        VStack(alignment: .center) {
            ZStack {
                Image(Picture.background3.rawValue)
                    .resizable()
                    .scaledToFill()
                    .padding(.top, 50)
                VStack {
                    Image(Picture.logo2.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .padding(.top, 25)
                        .scaleEffect(scaleAnimation ? 0 : logoSize)
                        .onAppear {
                            withAnimation(self.repeatingAnimation) { self.logoSize = 1.3 }
                        }

                    Image(Picture.headline2.rawValue)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 15)
                }
                .padding(.bottom, 15)
            }
            .onReceive(animationTimer) { _ in updateAnimation() }
            .opacity(startFadeoutAnimation ? 0 : 1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.leading, .trailing], 5)
        }
        .frame(maxWidth: .infinity)
        .background(Color(ComponentColor.darkBlue.rawValue))
        .edgesIgnoringSafeArea(.all)
        .padding(-10)
        .padding(.bottom)
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
        LaunchScreenView(launchScreenState: .firstStep)
    }
}
