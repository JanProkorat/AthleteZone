//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 5) {
            SettingsItem(title: "Language", content: {
                LanguagePicker()
            })
            .padding(.top, 20)
            
            SettingsItem(title: "Sounds", content: {
                Toggle("", isOn: $viewModel.appStorageManager.soundsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })
            
            SettingsItem(title: "Haptics (Watch only)", content: {
                Toggle("", isOn: $viewModel.appStorageManager.hapticsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })
                
            SettingsItem(title: "Allow notifications", content: {
                Toggle("", isOn: $viewModel.appStorageManager.notificationsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })
                
            Spacer()
        }
    }
}
                         
struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
            .environmentObject(WorkOutViewModel())
    }
}
