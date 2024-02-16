//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.07.2023.
//

import StoreKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var launchScreenStateManager = LaunchScreenStateManager()
    @StateObject var subscriptionManager = SubscriptionManager.shared
    @State var showingSignIn = false
    @State var isOfferCodeRedepmtionPresented = false

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.passIDs) private var passIDs

    var body: some View {
        ZStack(content: {
            switch viewModel.currentSection {
            case .workout:
                WorkOutContentScene()

            case .training:
                TrainingContentScene()

            case .stopWatch:
                StopWatchContentScene()
            }

            if launchScreenStateManager.state != .finished {
                LaunchScreenView()
                    .environmentObject(launchScreenStateManager)
            }
        })
        .environment(\.locale, .init(identifier: "\(viewModel.currentLanguage)"))
        .onAppear {
            self.launchScreenStateManager.dismiss()
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .animation(.default, value: viewModel.currentSection)
        .sheet(isPresented: $subscriptionManager.isSubscriptionViewVisible) {
            SubscriptionStoreView(groupID: passIDs.group)
                .storeButton(.visible, for: .policies, .redeemCode)
                .subscriptionStoreControlStyle(.prominentPicker)
                .subscriptionStorePolicyDestination(for: .privacyPolicy) {
                    WebView(url: URL(string: "https://sites.google.com/view/athlete-zone-privacy/domovsk%C3%A1-str%C3%A1nka")!)
                }
                .subscriptionStorePolicyDestination(for: .termsOfService) {
                    WebView(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                }
        }
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            if let value = taskStatus.value {
                let activated = value.contains(where: { $0.state != .revoked && $0.state != .expired })
                self.subscriptionManager.subscriptionActivated = activated
                if !activated && viewModel.currentSection != .workout {
                    viewModel.router.currentSection = .workout
                }
            } else {
                self.subscriptionManager.subscriptionActivated = false
            }
        }
        .task {
            await subscriptionManager.observeTransactionUpdates()
            await subscriptionManager.checkForUnfinishedTransactions()
        }
        .onInAppPurchaseCompletion { _, _ in
            self.subscriptionManager.isSubscriptionViewVisible.toggle()
        }
        .offerCodeRedemption(isPresented: $isOfferCodeRedepmtionPresented)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
