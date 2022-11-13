//
//  NumberPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct NumberPicker: View {
    
    let textColor: String
    
    init(textColor: String) {
        self.textColor = textColor
    }

    private var numbers = Array(1...50)
    
    @State private var selectedNumber = 1

    var body: some View {
        VStack(alignment: .center) {
            Picker(selection: $selectedNumber, label: Text("Number")) {
                ForEach((0 ..< self.numbers.count).reversed(), id: \.self) {
                    Text("\(self.numbers[$0])")
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
            
            Spacer()
        }
        .padding([.top], 25)
        .padding([.leading, .trailing], 10)


    }
}

struct NumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        NumberPicker(textColor: Colors.Rounds)
    }
}
