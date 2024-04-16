//
//  SectionSwitch.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import StoreKit
import SwiftUI

struct SectionSwitch: View {
    @Binding var currentSection: Section
    @Binding var subscriptionSheetVisible: Bool
    var subscriptionActivated: Bool
    @State var pendingSection: Section?

    var body: some View {
        Menu {
            ForEach(Section.allCases.sorted(by: { $0.rawValue > $1.rawValue }), id: \.self) { section in
                Button(action: {
                    if !subscriptionActivated {
                        pendingSection = section
                        subscriptionSheetVisible.toggle()
                    } else {
                        currentSection = section
                    }
                }, label: {
                    HStack {
                        Text(LocalizedStringKey(section.rawValue))
                            .frame(maxWidth: .infinity)

                        if section == currentSection {
                            Image(systemName: "checkmark")
                        } else if !subscriptionActivated {
                            Image(systemName: "lock")
                        }
                    }
                })
            }
        } label: {
            Image(Icon.arrowDown.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .frame(maxWidth: 55, maxHeight: 50)
        }
        .onChange(of: subscriptionActivated) { oldValue, newValue in
            if !oldValue && newValue {
                if let newSection = pendingSection {
                    self.currentSection = newSection
                    self.pendingSection = nil
                }
            }
        }
    }
}

struct SectionSwitch_Previews: PreviewProvider {
    static var previews: some View {
        SectionSwitch(
            currentSection: Binding.constant(.workout),
            subscriptionSheetVisible: Binding.constant(false),
            subscriptionActivated: false)
    }
}
