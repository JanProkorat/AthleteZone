//
//  TrainingEditContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.07.2023.
//

import RealmSwift
import SwiftUI

struct TrainingEditContent: View {
    @EnvironmentObject var viewModel: TrainingEditViewModel

    @Binding var isModalVisible: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass

    private var descriptionLineLimit: Int {
        verticalSizeClass == .compact ? 3 : 4
    }

    init(isModalVisible: Binding<Bool>) {
        self._isModalVisible = isModalVisible
        UICollectionView.appearance().backgroundColor = UIColor(Color(ComponentColor.darkBlue.rawValue))
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                EditSection(icon: "pencil.circle", label: LocalizationKey.name, color: ComponentColor.lightPink) {
                    EditField {
                        TextInput(text: $viewModel.name)
                    }
                    .padding(.bottom)
                    .frame(maxHeight: geo.size.height * 0.1)
                }

                EditSection(icon: "square.and.pencil.circle",
                            label: LocalizationKey.description,
                            color: ComponentColor.lightBlue) {
                    TextField(LocalizationKey.enterDescription.localizedKey,
                              text: $viewModel.description,
                              axis: .vertical)
                        .lineLimit(descriptionLineLimit, reservesSpace: true)
                        .textFieldStyle(EditFieldStyle())
                        .padding(.top, -10)
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .onChange(of: viewModel.description) { _, newValue in
                            viewModel.description = String(newValue.prefix(200))
                        }
                }

                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(ComponentColor.menu.rawValue))
                        .frame(height: 50)
                    Collapsible {
                        Image(systemName: "figure.run.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                            .frame(maxWidth: 35, maxHeight: 35)
                            .padding(.top, 5)

                        Text(LocalizationKey.workouts.localizedKey)
                            .font(.title)
                            .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                            .padding(.leading, 5)

                    } content: {
                        VStack {
                            Button {
                                isModalVisible.toggle()
                            } label: {
                                HStack(alignment: .center) {
                                    Image(Icons.add.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color(ComponentColor.mainText.rawValue))

                                    Text(LocalizationKey.addWorkouts.localizedKey)
                                        .font(.title2)
                                        .padding(.leading, 5)
                                        .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                                }
                                .background(ZStack {
                                    RoundedRectangle(cornerRadius: 13)
                                        .foregroundColor(Color(ComponentColor.menu.rawValue))
                                        .frame(width: geo.size.width * 0.98, height: geo.size.height * 0.096)
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                                        .frame(width: geo.size.width * 0.96, height: geo.size.height * 0.089)
                                })
                                .frame(maxWidth: .infinity)
                                .frame(height: geo.size.height * 0.09)
                                .background(Color(ComponentColor.darkBlue.rawValue))
                                .padding(.top, 2)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                            List {
                                ForEach(viewModel.workouts, id: \._id) { workout in
                                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.1)
                                }
                                .onDelete { indexSet in
                                    viewModel.workouts.remove(atOffsets: indexSet)
                                }
                                .onMove { from, to in
                                    viewModel.workouts.move(fromOffsets: from, toOffset: to)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                    .padding([.leading, .trailing], 5)
                    .padding(.bottom, 7)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
            }
        }
    }

    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

struct TrainingEditContent_Previews: PreviewProvider {
    static var previews: some View {
        TrainingEditContent(isModalVisible: Binding.constant(false))
            .environmentObject(TrainingEditViewModel())
    }
}

struct EditFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding([.leading, .trailing])
            .padding(.top, 5)
            .roundedBackground(cornerRadius: 10, color: ComponentColor.darkBlue)
            .padding()
    }
}
