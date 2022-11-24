//
//  ActivityView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.11.2022.
//

import SwiftUI

struct ActivityView: View {
    
    let image: String
    let color: String
    let activity: LocalizedStringKey
    let interval: Int
    let type: LabelType
    
    
    var body: some View {
        HStack(){
            HStack(){
                IconButton(id: "\(activity)Icon", image: image, color: color, width: 50, height: 45)
                    .padding(.leading, 10)
                Text(activity)
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .foregroundColor(Color(color))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(interval.toFormattedValue(type: type))
                .font(.custom("Lato-Black", size: 20))
                .bold()
                .foregroundColor(Color(color))
                .padding(.trailing)
            
        }
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 60)
                    .foregroundColor(Color("\(color)_background"))
            }
            
            
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 60)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 3)
        
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(image: Icons.Play, color: Colors.Work, activity: "Work", interval: 40, type: .time)
    }
}
