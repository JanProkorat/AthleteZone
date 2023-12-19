//
//  PrivacyPolicyView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.12.2023.
//

import RichText
import SwiftUI

struct PrivacyPolicyView: View {
    @State var html = ""

    var body: some View {
        ScrollView {
            RichText(html: html)
        }
        .padding()
        .onAppear {
            if let htmlFileURL = Bundle.main.url(forResource: "privacyPolicy", withExtension: "html") {
                do {
                    let htmlString = try String(contentsOf: htmlFileURL, encoding: .utf8)
                    html = htmlString
                } catch {
                    print("Error reading HTML file: \(error)")
                }
            } else {
                print("HTML file not found.")
            }
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
