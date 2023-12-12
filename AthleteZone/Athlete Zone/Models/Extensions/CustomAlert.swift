//
//  CustomAlert.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2023.
//

import CustomAlert
import Foundation
import SwiftUI

extension View {
    func addAlertConfiguration() -> some View {
        return self.environment(\.customAlertConfiguration, .create { configuration in
            configuration.background = .blurEffect(.dark)
            configuration.padding = EdgeInsets()
            configuration.alert = .create { alert in
                alert.background = .color(.darkBlue)
                alert.cornerRadius = 10
                alert.padding = EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
                alert.alignment = .center
                alert.contentFont = .subheadline
                alert.alignment = .leading
                alert.minWidth = 350
            }
        })
    }
}
