//
//  TimePicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct TimePicker: View {
    
    let textColor: String
    
    init(textColor: String) {
        self.textColor = textColor
    }

    private var hours = Array(0...23)
    private var minutes = Array(0...59)
    private var seconds = Array(0...59)
    
    @State private var selectedHours = 22
    @State private var selectedMins = 12
    @State private var selectedSecs = 42
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 5){
                Picker(selection: $selectedHours, label: Text("Hours")) {
                    ForEach((0 ..< self.hours.count).reversed(), id: \.self) {
                        Text("\(self.hours[$0])")
                            .foregroundColor(Color(textColor))
                            .font(.custom("Lato-Black", size: 30))

                    }
                }
                .background(
                    ZStack(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(Colors.Menu), lineWidth: 3)
                            .foregroundColor(Color(Backgrounds.WorkBackground))

                       
                    }
                    
                )
                .pickerStyle(InlinePickerStyle())
                Text(":")
                    .foregroundColor(Color(Colors.Work))
                    .font(.custom("Lato-Black", size: 60))
                
                Picker(selection: $selectedMins, label: Text("Mins")) {
                    ForEach((0 ..< self.minutes.count).reversed(), id: \.self) {
                        Text("\(self.minutes[$0])")
                            .foregroundColor(Color(textColor))
                            .font(.custom("Lato-Black", size: 30))

                    }
                }
                .background(
                    ZStack(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(Colors.Menu), lineWidth: 3)
                            .foregroundColor(Color(Backgrounds.WorkBackground))

                       
                    }
                    
                )
                .pickerStyle(InlinePickerStyle())
                Text(":")
                    .foregroundColor(Color(Colors.Work))
                    .font(.custom("Lato-Black", size: 60))

                
                Picker(selection: $selectedSecs, label: Text("Secs")) {
                    ForEach((0 ..< self.seconds.count).reversed(), id: \.self) {
                        Text("\(self.seconds[$0])")
                            .foregroundColor(Color(textColor))
                            .font(.custom("Lato-Black", size: 30))
                    }
                }
                .background(
                    ZStack(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(Colors.Menu), lineWidth: 3)
                            .foregroundColor(Color(Backgrounds.WorkBackground))

                       
                    }
                    
                )
                .pickerStyle(InlinePickerStyle())

            }
            .padding([.top], 25)
            Spacer()


        }
        .padding([.leading, .trailing], 10)


        
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(textColor: Colors.Work)
    }
}
