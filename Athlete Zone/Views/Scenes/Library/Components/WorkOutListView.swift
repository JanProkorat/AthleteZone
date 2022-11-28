//
//  WorkOutListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.11.2022.
//

import SwiftUI

struct WorkOutListView: View {
    
    let workOut: WorkOut
    
    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?

    
    var body: some View {
        VStack{
            HStack(){
                Text(workOut.name)
                    .font(.custom("Lato-Black", size: 35))
                    .bold()
                    .foregroundColor(Color(Colors.MainText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing)
                    .padding(.top, 25)
                    .padding(.leading, 30)
                Menu {
                    Button(action: {
                        if self.onEditTab != nil {
                            self.onEditTab!()
                        }
                    }, label: {
                        Label("Edit", systemImage: "pencil")
                    })

                    Button(role: .destructive, action: {
                        print(self.workOut)
                        if self.onDeleteTab != nil {
                            self.onDeleteTab!()
                        }
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                } label: {
                    Image(Icons.Menu)
                        .foregroundColor(Color(Colors.MainText))
                        .frame(width: 40, height: 34)
                        .padding(.trailing, 20)
                        .padding(.top)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
            HStack(){
                HStack(){
                    ListViewText(text: "Work:", color: Colors.Work)
                    ListViewText(text: workOut.work.toFormattedTime(), color: Colors.Work)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                HStack(){
                    ListViewText(text: "Rounds:", color: Colors.Rounds)
                    ListViewText(text: workOut.rounds.toFormattedValue(type:.number), color: Colors.Rounds)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

            }
            .padding(.top, 1)
            .padding(.leading, 25)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(){
                HStack(){
                    ListViewText(text: "Rest:", color: Colors.Rest)
                    ListViewText(text: workOut.rest.toFormattedTime(), color: Colors.Rest)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                HStack(){
                    ListViewText(text: "Reset:", color: Colors.Reset)
                    ListViewText(text: workOut.series.toFormattedValue(type:.time), color: Colors.Reset)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .padding(.top, 1)
            .padding(.leading, 25)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(){
                HStack(){
                    ListViewText(text: "Series:", color: Colors.Series)
                    ListViewText(text: workOut.series.toFormattedValue(type: .number), color: Colors.Series)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                HStack(){
                    ListViewText(text: "Total:", color: Colors.MainText)
                    ListViewText(text: workOut.timeOverview.toFormattedTime(), color: Colors.MainText)
                        .padding(.leading, 3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

            }
            .padding(.top, 1)
            .padding(.leading, 25)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(Backgrounds.WorkBackground))
                .padding([.top, .leading, .trailing])

        )
    }
}

struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(workOut: WorkOut())
    }
}

extension WorkOutListView {
    func onEditTab(_ handler: @escaping () -> Void) -> WorkOutListView {
        var new = self
        new.onEditTab = handler
        return new
    }
    
    func onDeleteTab(_ handler: @escaping () -> Void) -> WorkOutListView {
        var new = self
        new.onDeleteTab = handler
        return new
    }
    
    
}
