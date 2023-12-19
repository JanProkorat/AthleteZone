//
//  SectionSwitch.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import StoreKit
import SwiftUI

struct SectionSwitch: View {
    @StateObject var router = ViewRouter.shared
    @StateObject var subscriptionManager = SubscriptionManager.shared
    @State var pendingSection: Section?

    var body: some View {
        Menu {
            ForEach(Section.allCases.sorted(by: { $0.rawValue > $1.rawValue }), id: \.self) { section in
                Button(action: {
                    if !subscriptionManager.subscriptionActivated {
                        pendingSection = section
                        subscriptionManager.isSubscriptionViewVisible.toggle()
                    } else {
                        router.currentSection = section
                    }
                }, label: {
                    HStack {
                        Text(LocalizedStringKey(section.rawValue))
                            .frame(maxWidth: .infinity)

                        if section == router.currentSection {
                            Image(systemName: "checkmark")
                        } else if !subscriptionManager.subscriptionActivated {
                            Image(systemName: "lock")
                        }
                    }
                })
            }
        } label: {
            Image(Icons.arrowDown.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .frame(maxWidth: 55, maxHeight: 50)
        }
        .onChange(of: subscriptionManager.subscriptionActivated) { oldValue, newValue in
            if !oldValue && newValue {
                if let newSection = pendingSection {
                    self.router.currentSection = newSection
                    self.pendingSection = nil
                }
            }
        }
    }
}

struct SectionSwitch_Previews: PreviewProvider {
    static var previews: some View {
        SectionSwitch()
    }
}
