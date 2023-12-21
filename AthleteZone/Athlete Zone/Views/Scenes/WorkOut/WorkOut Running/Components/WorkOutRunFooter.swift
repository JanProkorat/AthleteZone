//
//  WorkOutRunFooter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.12.2022.
//

import SwiftUI

struct WorkOutRunFooter: View {
    @EnvironmentObject var viewModel: PhoneWorkOutRunViewModel

    var body: some View {
        Button {
            if viewModel.state == .running {
                self.viewModel.selectedFlowIndex -= 1
            } else {
                viewModel.state = .quit
            }
        } label: {
            Text(getLabel())
                .font(.title3)
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
        return viewModel.state == .paused || viewModel.state == .finished ?
            LocalizationKey.quitWorkout.localizedKey : ""
    }
}

struct WorkOutRunFooter_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhoneWorkOutRunViewModel()
        viewModel.setupViewModel(workout: WorkOut("Title", 30, 60, 2, 1, 120))
        return WorkOutRunFooter()
            .environmentObject(viewModel)
    }
}
