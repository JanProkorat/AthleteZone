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

    var body: some View {
        GeometryReader { geo in
            VStack {
                EditSection(icon: "pencil.circle", label: "Name", color: ComponentColor.work) {
                    EditField {
                        TextInput(text: $viewModel.name)
                    }
                    .padding(.bottom)
                }

                EditSection(icon: "square.and.pencil.circle", label: "Description", color: ComponentColor.series) {
                    ScrollView {
                        TextField("Enter description...",
                                  text: $viewModel.description,
                                  axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .textFieldStyle(EditFieldStyle())
                            .padding(.top, -15)
                    }
                    .frame(maxHeight: geo.size.height * 0.22)
                }

                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(ComponentColor.menu.rawValue))
                        .frame(height: 50)
                    Collapsible {
                        Image(systemName: "figure.run.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.rounds.rawValue))
                            .frame(maxWidth: 35, maxHeight: 35)
                            .padding(.top, 5)

                        Text("Workouts")
                            .font(.title)
                            .foregroundColor(Color(ComponentColor.rounds.rawValue))
                            .padding(.leading, 5)

                    } content: {
                        if viewModel.workouts.isEmpty {
                            emptyListSection(geo: geo)
                        } else {
                            notEmptyListSection(geo: geo)
                        }
                    }
                    .padding([.leading, .trailing], 5)
                    .padding(.bottom, 7)
                }
            }
            .animation(.easeOut)
            .transition(.slide)
        }
    }

    @ViewBuilder
    func emptyListSection(geo: GeometryProxy) -> some View {
        Button {
            isModalVisible.toggle()
        } label: {
            HStack {
                VStack {
                    Image(Icons.add.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    Text("Add workouts")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.title2)
                        .padding(.top, 5)
                }
            }
            .padding([.leading, .trailing])
            .background(ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
                    .frame(height: geo.size.height * 0.3)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(Background.background.rawValue))
                    .frame(width: geo.size.width * 0.96, height: geo.size.height * 0.29)
            })
            .frame(maxWidth: .infinity)
            .frame(height: geo.size.height * 0.3)
            .padding(.bottom, 2)
            .padding(.top, 5)
            .background(Color(Background.background.rawValue))
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    @ViewBuilder
    func notEmptyListSection(geo: GeometryProxy) -> some View {
        VStack {
            Button {
                isModalVisible.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image(Icons.add.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)

                    Text("Add workouts")
                        .font(.title2)
                        .padding(.leading, 5)
                }
                .background(ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .foregroundColor(Color(ComponentColor.menu.rawValue))
                        .frame(width: geo.size.width * 0.98, height: geo.size.height * 0.096)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(Background.background.rawValue))
                        .frame(width: geo.size.width * 0.96, height: geo.size.height * 0.089)
                })
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height * 0.09)
                .background(Color(Background.background.rawValue))
                .padding(.top, 2)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            List {
                ForEach(viewModel.workouts, id: \._id) { workout in
                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.1)
                }
                .onMove { from, to in
                    viewModel.workouts.move(fromOffsets: from, toOffset: to)
                }
            }
            .listStyle(.plain)
        }
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
            .padding([.leading, .trailing, .top])
            .roundedBackground(cornerRadius: 10, color: ComponentColor.darkBlue)
            .padding()
    }
}
