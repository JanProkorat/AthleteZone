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
            Text(getLabel())
                .font(.headline)
                .bold()
        }
        .padding(.top, 10)
        .frame(height: 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(Color(ComponentColor.mainText.rawValue))
    }

    func getLabel() -> LocalizedStringKey {
        if viewModel.selectedFlowIndex > 0 {
            switch viewModel.state {
            case .paused:
                return LocalizationKey.quitWorkout.localizedKey

            case .finished:
                return LocalizationKey.quitWorkout.localizedKey

            default:
                return LocalizationKey.previousExercise.localizedKey
            }
        }
        return viewModel.state == .paused ||
            viewModel.state == .finished ||
            viewModel.state == .ready ? LocalizationKey.quitWorkout.localizedKey : ""
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
