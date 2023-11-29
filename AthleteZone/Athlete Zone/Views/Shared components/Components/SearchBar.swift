//
//  SearchBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 22.12.2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(LocalizationKey.search.localizedKey, text: $text)
                .frame(height: 40)
                .padding([.leading], 10)
                .padding(.horizontal, 25)
                .background(Color(ComponentColor.menu.rawValue))
                .cornerRadius(13)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }

            if isEditing {
                Button {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""

                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                        )
                    }
                } label: {
                    Text(LocalizationKey.cancel.localizedKey)
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                        .padding(.leading, 10)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var str = "ahoj"

    static var previews: some View {
        SearchBar(text: $str)
    }
}
