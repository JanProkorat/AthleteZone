//
//  IconButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.11.2022.
//

import SwiftUI

struct IconButton: View, Identifiable {
    let id: String
    
    let image: String
    let color: String
    let width: CGFloat
    let height: CGFloat
    var selected: Bool?
    
    var onTab: (() -> Void)?
    
    var body: some View {
        Button(action: {
            if self.onTab != nil{
                self.onTab!()
            }
        }, label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(color))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(self.selected ?? false ? Colors.Action : ""), lineWidth: 4)
                        .frame(width: 40, height: 34)
                )
            
            
        })
        .frame(width: width, height: height)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(id: "arrowDown", image: Icons.ArrowDown, color: Colors.MainText, width: 50, height: 45, selected: true)
    }
}

extension IconButton {
    
    func onTab(_ handler: @escaping () -> Void) -> IconButton {
        var new = self
        new.onTab = handler
        return new
    }
}
