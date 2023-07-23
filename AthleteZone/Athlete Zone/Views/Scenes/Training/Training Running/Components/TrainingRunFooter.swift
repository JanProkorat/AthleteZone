//
//  TrainingRunFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.05.2023.
//

import SwiftUI

struct TrainingRunFooter: View {
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
        return viewModel.state == .paused ||
            viewModel.state == .finished ||
            viewModel.state == .ready ? "Quit workout" : ""
    }
}

struct TrainingRunFooter_Previews: PreviewProvider {
    static var previews: some View {
        TrainingRunFooter()
            .environmentObject(WorkOutRunViewModel(workout: WorkOut()))
    }
}

extension TrainingRunFooter {
    func onQuitTab(_ handler: @escaping () -> Void) -> TrainingRunFooter {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
