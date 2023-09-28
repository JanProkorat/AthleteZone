//
//  TrainingRunFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.05.2023.
//

import SwiftUI

struct TrainingRunFooter: View {
    @EnvironmentObject var viewModel: PhoneWorkOutRunViewModel

    var body: some View {
        Button {
            if viewModel.state != .running {
                viewModel.state = .quit
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
        let viewModel = PhoneWorkOutRunViewModel()
        viewModel.setupViewModel(workout: WorkOut("Title", 30, 60, 2, 1, 120))
        return TrainingRunFooter()
            .environmentObject(viewModel)
    }
}
