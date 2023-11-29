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
                    text: LocalizationKey.save,
                    color: viewModel.saveDisabled ? .grey : .lightGreen,
                    backgoundColor: ComponentColor.menu.rawValue,
                    image: Icons.check.rawValue,
                    height: 60,
                    cornerRadius: nil
                )
            })
            .onTab { self.performAction(onSaveTab) }
            .disabled(viewModel.saveDisabled)

            ActionButton(content: {
                ActionView(
                    text: LocalizationKey.cancel,
                    color: ComponentColor.lightPink,
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
            .environmentObject(WorkOutEditViewModel(workout: WorkOut()))
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
