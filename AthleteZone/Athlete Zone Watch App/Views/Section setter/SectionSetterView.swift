//
//  SectionPickerView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import SwiftUI

struct SectionSetterView: View {
    @EnvironmentObject var viewModel: ContentViewModel

    var body: some View {
        BaseView(title: LocalizedStringKey("Section")) {
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Spacer()

                    ForEach(Section.allCases, id: \.self) { section in
                        Button {
                            viewModel.appStorageManager.selectedSection = section
                        } label: {
                            HStack {
                                Text(section.rawValue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if section == viewModel.currentSection {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding([.leading, .trailing])
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: geo.size.height * 0.25)
                                        .foregroundColor(Color(Background.listItemBackground.rawValue))
                                }
                            )
                        }
                        .padding(.bottom, 40)
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
            }
        }
    }
}

struct SectionSetterView_Previews: PreviewProvider {
    static var previews: some View {
        SectionSetterView()
            .environmentObject(ContentViewModel())
    }
}
