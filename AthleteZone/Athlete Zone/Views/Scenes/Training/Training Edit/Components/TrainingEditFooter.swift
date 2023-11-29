//
//  TrainingEditFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.07.2023.
//

import SwiftUI

struct TrainingEditFooter: View {
    @EnvironmentObject var viewModel: TrainingEditViewModel

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
            .onTab { self.performAction(onCloseTab) }
        }
    }
}

struct TrainingEditFooter_Previews: PreviewProvider {
    static var previews: some View {
        TrainingEditFooter()
            .environmentObject(TrainingEditViewModel())
    }
}

extension TrainingEditFooter {
    func onCloseTab(_ handler: @escaping () -> Void) -> TrainingEditFooter {
        var new = self
        new.onCloseTab = handler
        return new
    }

    func onSaveTab(_ handler: @escaping () -> Void) -> TrainingEditFooter {
        var new = self
        new.onSaveTab = handler
        return new
    }
}
