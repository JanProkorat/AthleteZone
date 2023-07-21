//
//  TrainingRunHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.04.2023.
//

import SwiftUI

struct TrainingRunHeader: View {
    let title: String

    var body: some View {
        TitleText(text: title, alignment: .center)
    }
}

struct TrainingRunHeader_Previews: PreviewProvider {
    static var previews: some View {
        TrainingRunHeader(title: "Training")
    }
}
