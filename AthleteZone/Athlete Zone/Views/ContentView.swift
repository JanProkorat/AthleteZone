//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.07.2023.
//

import ComposableArchitecture
import StoreKit
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<ContentFeature>

    @State var isOfferCodeRedepmtionPresented = false

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.passIDs) private var passIDs

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    HStack(alignment: .center) {
                        SectionSwitch(
                            currentSection: $store.currentSection.sending(\.sectionChanged),
                            subscriptionSheetVisible: $store.subscriptionSheetVisible.sending(\.subscriptionSheetVisibilityChanged),
                            subscriptionActivated: store.subscriptionActivated
                        )
                        TitleText(text: store.title)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    switch store.currentSection {
                    case .workout:
                        if store.currentTab == .home {
                            headerButton(icon: Icon.save)
                        }
                        if store.currentTab == .library {
                            headerButton(icon: Icon.add)
                        }

                    case .training:
                        if store.currentTab == .home, !store.title.isEmpty {
                            headerButtonWithSystemIcon
                        }
                        if store.currentTab == .library {
                            headerButton(icon: Icon.add)
                        }

                    case .stopWatch:
                        if store.currentTab == .home {
                            HStack {
                                timeTrackingSectionButton(id: "timer", .timer)
                                    .padding(.trailing, 3)
                                timeTrackingSectionButton(id: "stopwatch", .stopWatch)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.08)

                VStack {
                    switch store.currentSection {
                    case .workout:
                        if let store = store.scope(state: \.destination?.workout, action: \.destination.workout) {
                            WorkOutContentView(store: store)
                        }

                    case .training:
                        if let store = store.scope(state: \.destination?.training, action: \.destination.training) {
                            TrainingContentView(store: store)
                        }

                    case .stopWatch:
                        if let store = store.scope(state: \.destination?.stopwatch, action: \.destination.stopwatch) {
                            TimeTrackingContentView(store: store)
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.contentSize, geometry.size)

                MenuBar(activeTab: store.currentTab)
                    .onRouteTab { store.send(.tabChanged($0)) }
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geometry.size.height * 0.1)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .top)
            .background(Color(ComponentColor.darkBlue.rawValue))
            .environment(\.colorScheme, .dark)
            .environment(\.footerSize, geometry.size.height * 0.1)
            .environment(\.contentSize, geometry.size)
            .environment(\.locale, .init(identifier: "\(store.currentLanguage)"))
            .animation(.default, value: store.currentSection)
            .overlay {
                if store.launchScreenState != .finished {
                    LaunchScreenView(launchScreenState: store.launchScreenState)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
        .ignoresSafeArea(.keyboard, edges: [.bottom])
        .sheet(item: $store.scope(state: \.subscriptionSheet, action: \.subscriptionSheet), content: { _ in
            SubscriptionStoreView(groupID: passIDs.group)
                .storeButton(.visible, for: .policies, .redeemCode)
                .subscriptionStoreControlStyle(.prominentPicker)
                .subscriptionStorePolicyDestination(for: .privacyPolicy) {
                    WebView(url: URL(string: "https://sites.google.com/view/athlete-zone-privacy/domovsk%C3%A1-str%C3%A1nka")!)
                }
                .subscriptionStorePolicyDestination(for: .termsOfService) {
                    WebView(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                }
        })
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            if let value = taskStatus.value {
                let activated = value.contains(where: { $0.state != .revoked && $0.state != .expired })
                store.send(.subscriptionStatusChanged(activated))
                if !activated && store.currentSection != .workout {
                    store.send(.sectionChanged(.workout))
                }
            } else {
                store.send(.subscriptionStatusChanged(false))
            }
        }
        .task { store.send(.observeTransactions) }
        .onInAppPurchaseCompletion { _, _ in
            store.send(.purchaseCompleted)
        }
        .offerCodeRedemption(isPresented: $isOfferCodeRedepmtionPresented)
    }

    @ViewBuilder
    func headerButton(icon: Icon) -> some View {
        Button {
            store.send(.saveTapped)
        } label: {
            Image(icon.rawValue)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .frame(maxHeight: 50)
        }
    }

    @ViewBuilder
    var headerButtonWithSystemIcon: some View {
        Button {
            store.send(.saveTapped)
        } label: {
            HStack {
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxHeight: 20)
                    .padding(10)
            }
            .roundedBackground(cornerRadius: 10, color: .darkBlue, border: ComponentColor.mainText, borderWidth: 3)
            .padding(.trailing, 5)
        }
    }

    @ViewBuilder
    func timeTrackingSectionButton(id: String, _ valueToSet: TimerType) -> some View {
        Button {
            store.send(.timeTractingSectionChanged(valueToSet))
        } label: {
            if store.timeTractingSection == valueToSet {
                sectionIcon(
                    id: id,
                    color: .darkBlue,
                    background: .action,
                    border: .action
                )
            } else {
                sectionIcon(
                    id: id,
                    color: .mainText,
                    background: .darkBlue,
                    border: .mainText
                )
            }
        }
    }

    @ViewBuilder
    func sectionIcon(id: String, color: ComponentColor, background: ComponentColor, border: ComponentColor) -> some View {
        Image(systemName: id)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(color.rawValue))
            .frame(maxHeight: 30)
            .padding(5)
            .roundedBackground(cornerRadius: 10, color: background, border: border)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: ComposableArchitecture.Store(initialState: ContentFeature.State()) {
            ContentFeature()
                ._printChanges()
        })
    }
}
