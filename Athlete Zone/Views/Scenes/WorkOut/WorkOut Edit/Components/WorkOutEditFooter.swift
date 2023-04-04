//
//  WorkOutEditFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2022.
//

import SwiftUI

struct WorkOutEditFooter: View {
    @EnvironmentObject var viewModel: WorkOutEditViewModel
    var onCloseTab: (() -> Void)?
    var onSaveTab: (() -> Void)?

    var body: some View {
        VStack(spacing: 5) {
            ActionButton(content: {
                ActionView(
                    text: "Save",
                    color: viewModel.isValid ? .rounds : .grey,
                    backgoundColor: ComponentColor.menu.rawValue,
                    image: Icons.check.rawValue,
                    height: 60,
                    cornerRadius: nil
                )
            })
            .onTab { self.performAction(onSaveTab) }
            .disabled(!viewModel.isValid)

            ActionButton(content: {
                ActionView(
                    text: "Cancel",
                    color: ComponentColor.work,
                    backgoundColor: ComponentColor.menu.rawValue,
                    image: Icons.clear.rawValue,
                    height: 60,
                    cornerRadius: nil
                )
            })
            .onTab { self.performAction(self.onCloseTab) }
        }
    }
}

struct WorkOutEditFooter_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditFooter()
            .environmentObject(WorkOutEditViewModel())
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
