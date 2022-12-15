//
//  WorkOutEditFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2022.
//

import SwiftUI

struct WorkOutEditFooter: View {
    var onCloseTab: (() -> Void)?
    var onSaveTab: (() -> Void)?

    var body: some View {
        VStack(spacing: 5) {
            ActionButton(
                innerComponent: ActionView(
                    text: "Save",
                    color: Colors.Rounds,
                    backgoundColor: nil,
                    image: Icons.Check,
                    height: 55,
                    cornerRadius: nil
                )
            )
            .onTab { self.performAction(onSaveTab) }

            ActionButton(
                innerComponent: ActionView(
                    text: "Cancel",
                    color: Colors.Work,
                    backgoundColor: nil,
                    image: Icons.Clear,
                    height: 60,
                    cornerRadius: nil
                )
            )
            .onTab { self.performAction(self.onCloseTab) }
        }
        .padding([.leading, .trailing])
    }
}

struct WorkOutEditFooter_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditFooter()
    }
}

extension WorkOutEditFooter {
    func onCloseTab(_ handler: @escaping () -> Void) -> WorkOutEditFooter {
        var new = self
        new.onCloseTab = handler
        return new
    }

    func onSaveTab(_ handler: @escaping () -> Void) -> WorkOutEditFooter {
        var new = self
        new.onSaveTab = handler
        return new
    }
}
