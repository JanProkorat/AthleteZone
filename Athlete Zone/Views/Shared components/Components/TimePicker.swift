//
//  TimePicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct TimePicker: View {
    
    let textColor: String
    var onValueChange: ((_ value: Int) -> Void)?
    
    private var hours = Array(0...23)
    private var minutes = Array(0...59)
    private var seconds = Array(0...59)
    
    @State var selectedHours: Int = 0
    @State var selectedMins: Int = 0
    @State var selectedSecs: Int = 0
    
    init(textColor: String, interval: Int) {
        self.textColor = textColor
        self._selectedHours = State<Int>(initialValue: interval.toHours())
        self._selectedMins = State<Int>(initialValue: interval.toMinutes())
        self._selectedSecs = State<Int>(initialValue:interval.toSeconds());
    }
    
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
        .onChange(of: selectedHours, perform: { newValue in
            constructTimeInterval()
        })
        .onChange(of: selectedMins, perform: { newValue in
            constructTimeInterval()
        })
        .onChange(of: selectedSecs, perform: { newValue in
            constructTimeInterval()
        })

        
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(textColor: Colors.Work, interval: 61)
    }
}

extension TimePicker {
    func onValueChange(_ handler: @escaping (_ value: Int) -> Void) -> TimePicker {
        var new = self
        new.onValueChange = handler
        return new
    }
    
    func constructTimeInterval(){
        if onValueChange != nil {
            let interval = self.selectedHours * 3600 + self.selectedMins * 60 + self.selectedSecs
            onValueChange!(interval)
        }
    }
}
