//
//  ActivityButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct ActivityButton: View {
    let innerComponent: ActivityView
    var onTab: (() -> Void)?

    var body: some View {
        Button(action: {
            self.performAction(onTab)
        }, label: {
            innerComponent
        })
        .frame(maxWidth: .infinity)
    }
}

struct ActivityButton_Previews: PreviewProvider {
    static var previews: some View {
        ActivityButton(
            innerComponent: ActivityView(
                image: Icons.Play,
                color: Colors.Work,
                activity: "Work",
                interval: 40,
                type: .time
            )
        )
    }
}

extension ActivityButton {
    func onTab(_ handler: @escaping () -> Void) -> ActivityButton {
        var new = self
        new.onTab = handler
        return new
    }
}
