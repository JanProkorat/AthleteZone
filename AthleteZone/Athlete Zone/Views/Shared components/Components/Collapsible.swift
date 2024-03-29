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

    @State var collapsed: Bool
    @State var disabled = false

    init(collapsed: Binding<Bool>? = nil, disabled: Bool = false,
         @ViewBuilder label: () -> Label,
         @ViewBuilder content: () -> Content)
    {
        _collapsed = State(initialValue: collapsed?.wrappedValue ?? false)
        _disabled = State(initialValue: disabled)
        self.label = label()
        self.content = content()
    }

    var body: some View {
        VStack {
            Button(
                action: {
                    withAnimation {
                        self.collapsed.toggle()
                    }
                },
                label: {
                    HStack {
                        label
                        Spacer()
                        if !disabled {
                            Image(systemName: self.collapsed ? "chevron.left" : "chevron.down")
                                .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                        }
                    }
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 10)
                    .background(Color.white.opacity(0.01))
                }
            )
            .disabled(disabled)
            .buttonStyle(NoTapAnimationStyle())

            VStack {
                content
                    .allowsHitTesting(!collapsed)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut, value: collapsed)
            .transition(.slide)
        }
    }
}

struct Collapsible_Previews: PreviewProvider {
    static var previews: some View {
        let collapsed = Binding<Bool>(
            get: { false },
            set: { _ in }
        )
        Collapsible(collapsed: collapsed) {
            Text("Section")
        } content: {
            Text("test")
        }
    }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}
