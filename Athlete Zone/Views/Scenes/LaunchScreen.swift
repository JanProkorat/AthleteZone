//
//  LaunchScreen.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack(alignment: .center) {
            Image(Pictures.Welcome)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(Backgrounds.Background))
                .edgesIgnoringSafeArea(.all)
            
            Image(Pictures.Logo)
        }
    }
    
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
