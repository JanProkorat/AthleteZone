//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    
    @AppStorage("language") private var language: Language = .en
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .center, spacing: 5){
                Text("Language")
                    .frame(height: 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(Colors.MainText))
                    .font(.custom("Lato-Bold", size: 25))
                    .padding(.leading)
                HStack(alignment: .center, spacing: 5) {
                    IconButton(id: "\(Language.cze)", image: Icons.FlagCZ, color: "", width: 40, height: 35, selected: self.language == Language.cze)
                        .onTab{
                            self.language = Language.cze
                        }
                    IconButton(id: "\(Language.de)", image: Icons.FlagDE, color: "", width: 40, height: 35, selected: self.language == Language.de)
                        .onTab{
                            self.language = Language.de
                        }
                        .padding(.leading)
                        
                    IconButton(id: "\(Language.en)", image: Icons.FlagGB, color: "", width: 40, height: 35, selected: self.language == Language.en)
                        .onTab{
                            self.language = Language.en
                        }
                        .padding(.leading)
                        

                }
                .padding()

            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(Colors.Menu))
            )
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 10)
            .padding(.top, 20)
            Spacer()
        }
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
    }
}
