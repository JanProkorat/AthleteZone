//
//  WorkOutRunFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.12.2022.
//

import SwiftUI

struct WorkOutRunFooter: View {
    @EnvironmentObject var viewModel: WorkOutRunViewModel

    var onQuitTab: (() -> Void)?

    var body: some View {
        Button {
            if viewModel.state != .running {
                self.performAction(onQuitTab)
            } else {
                self.viewModel.selectedFlowIndex -= 1
            }
        } label: {
            Text(LocalizedStringKey(getLabel()))
                .font(.custom("Lato-ThinItalic", size: 20))
                .bold()
        }
        .padding(.top, 10)
        .frame(height: 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(Color(ComponentColor.mainText.rawValue))
    }

    func getLabel() -> String {
        if viewModel.selectedFlowIndex > 0 {
            switch viewModel.state {
            case .paused:
                return "Quit workout"
            case .finished:
                return "Quit workout"
            default:
                return "Previous exercise"
            }
        }
        return viewModel.state == .paused || viewModel.state == .finished ? "Quit workout" : ""
    }
}

struct WorkOutRunFooter_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunFooter()
            .environmentObject(WorkOutRunViewModel(workout: WorkOut()))
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
