//
//  WorkOutRunFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.12.2022.
//

import SwiftUI

struct WorkOutRunFooter: View {
    @EnvironmentObject var viewModel: WorkFlowViewModel

    var isRunning: Bool

    var onQuitTab: (() -> Void)?

    var body: some View {
        Button {
            if !isRunning {
                self.performAction(onQuitTab)
            } else {
                self.viewModel.selectedFlowIndex -= 1
            }
        } label: {
            if self.viewModel.selectedFlowIndex > 0 || !isRunning {
                Text(LocalizedStringKey(isRunning ? "Previous exercise" : "Quit workout"))
                    .font(.custom("Lato-ThinItalic", size: 20))
                    .bold()
            }
        }
        .padding(.top, 10)
        .frame(height: 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(Color(ComponentColor.mainText.rawValue))
    }
}

struct WorkOutRunFooter_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunFooter(isRunning: true)
            .environmentObject(WorkFlowViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel())
    }
}

extension WorkOutRunFooter {
    func onQuitTab(_ handler: @escaping () -> Void) -> WorkOutRunFooter {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
