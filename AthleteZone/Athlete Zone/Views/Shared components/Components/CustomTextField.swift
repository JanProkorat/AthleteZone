//
//  CustomTextField.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.12.2023.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: LocalizedStringKey = ""
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .frame(height: 40)
                .padding([.leading], 0)
                .padding(.horizontal, 25)
                .background(Color(ComponentColor.menu.rawValue))
                .cornerRadius(13)
                .overlay(
                    HStack {
                        if isEditing {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                )
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
        }
    }
}

#Preview {
    CustomTextField(placeholder: "Name ...", text: Binding.constant(""))
}
