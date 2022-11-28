//
//  ExerciseEditContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct ExerciseEditContent: View {
    
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    
    var onCloseTab: (() -> Void)?
    
    var body: some View {
        GeometryReader{geo in
            VStack(spacing: 15){
                VStack(alignment: .leading, spacing: 5){
                    EditField(value: viewModel.workOutToEdit.name, label: "Name", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.1, color: Colors.MainText, type: .text)
                        .onNameChange { value in
                            self.viewModel.workOutToEdit.name = value
                        }
                }
                .frame(alignment: .leading)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(Colors.Menu))
                )
                
                VStack(alignment: .leading, spacing: 5){
                    HStack(alignment: .center, spacing: 5){
                        EditField(value: viewModel.workOutToEdit.work.toFormattedTime(), label: "Work", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.07, color: Colors.Work, type: .time)
                            .onTab{ self.router.setActiveEditSheet(.work) }
                            
                        EditField(value: viewModel.workOutToEdit.rounds.toFormattedValue(type: .number), label: "Rounds", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.07, color: Colors.Rounds, type: .number)
                            .onTab{ self.router.setActiveEditSheet(.rounds) }

                    }
                    .frame(height: geo.size.height * 0.55 * 0.25)
                    .padding(.top)
                    
                    HStack(alignment: .center, spacing: 5){
                        EditField(value: viewModel.workOutToEdit.rest.toFormattedTime(), label: "Rest", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.07, color: Colors.Work, type: .time)
                            .onTab{ self.router.setActiveEditSheet(.rest) }

                        EditField(value: viewModel.workOutToEdit.reset.toFormattedTime(), label: "Reset", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.07, color: Colors.Reset, type: .time)
                            .onTab{ self.router.setActiveEditSheet(.reset) }

                        
                    }
                    .frame(height: geo.size.height * 0.55 * 0.25)
                    .padding(.top, 10)

                    HStack(alignment: .center, spacing: 5){
                        EditField(value: viewModel.workOutToEdit.series.toFormattedValue(type: .number), label: "Series", labelSize: geo.size.height * 0.04, fieldSize: geo.size.height * 0.07, color: Colors.Series, type: .number)
                            .onTab{ self.router.setActiveEditSheet(.series) }

                        VStack(alignment: .leading, spacing: 5){
                           
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .frame(height: geo.size.height * 0.55  * 0.25)
                    .padding(.top, 10)


                }
                .frame(height: geo.size.height * 0.5, alignment: .top)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(Colors.Menu))
                )
                
                VStack(spacing: 5) {
                    ActionButton(innerComponent: ActionView(text: "Save", color: Colors.Rounds, backgoundColor: nil, image: Icons.Check, height: geo.size.height * 0.20 / 2, cornerRadius: nil))
                        .onTab {
                            viewModel.setSelectedWorkOut(viewModel.saveWorkOut())
                            if self.onCloseTab != nil {
                                self.onCloseTab!()
                            }
                        }
                    ActionButton(innerComponent: ActionView(text: "Cancel", color: Colors.Work, backgoundColor: nil, image: Icons.Clear, height: geo.size.height * 0.20 / 2, cornerRadius: nil))
                        .onTab{
                            if self.onCloseTab != nil {
                                self.onCloseTab!()
                            }
                        }
                }
                .frame(height: geo.size.height * 0.25, alignment: .top)
            }
        }
        .padding([.leading, .trailing, .top])
    }
}

struct ExerciseEditContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditContent()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension ExerciseEditContent {
    func onCloseTab(_ handler: @escaping () -> Void) -> ExerciseEditContent {
        var new = self
        new.onCloseTab = handler
        return new
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "clear")
                            .foregroundColor(Color(Colors.MainText))
                    }
                )
            }
        }
    }
}
