//
//  TextInput.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.03.2023.
//

import SwiftUI

struct TextInput: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(LocalizationKey.enterName.localizedKey, text: $text)
                .textFieldStyle(TextInputStyle(height: 50))
                .frame(height: 50)
                .overlay(
                    HStack {
                        if isEditing && !text.isEmpty {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 25)
                )
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
                .onChange(of: text) { _, newValue in
                    text = String(newValue.prefix(20))
                }

            if isEditing {
                Button {
                    withAnimation {
                        self.isEditing = false

                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                        )
                    }
                } label: {
                    Text(LocalizationKey.close.localizedKey)
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                }
                .padding(.trailing, 20)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct TextInput_Previews: PreviewProvider {
    static var previews: some View {
        let text = Binding.constant("test")
        TextInput(text: text)
    }
}
