//
//  Collapsible.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.03.2023.
//

import SwiftUI

struct Collapsible<Label: View, Content: View>: View {
    var label: Label
    var content: Content

    @State var collapsed = false
    @State var disabled = false

    init(collapsed: Bool = false, disabled: Bool = false,
         @ViewBuilder label: () -> Label,
         @ViewBuilder content: () -> Content)
    {
        _collapsed = State(initialValue: collapsed)
        _disabled = State(initialValue: disabled)
        self.label = label()
        self.content = content()
    }

    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        label
                        Spacer()
                        if !disabled {
                            Image(systemName: self.collapsed ? "chevron.left" : "chevron.down")
                        }
                    }
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 10)
                    .background(Color.white.opacity(0.01))
                }
            )
            .disabled(disabled)

            VStack {
                content
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut)
            .transition(.slide)
        }
    }
}

struct Collapsible_Previews: PreviewProvider {
    static var previews: some View {
        Collapsible {
            Text("Section")
        } content: {
            Text("test")
        }
    }
}
