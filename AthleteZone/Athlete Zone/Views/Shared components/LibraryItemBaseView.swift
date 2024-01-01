//
//  LibraryItemBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2023.
//

import SwiftUI

struct LibraryItemBaseView<Content: View>: View {
    let content: Content
    var name: String

    var onInfoTab: (() -> Void)?
    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?

    var infoEnabled = true
    var editEnabled = true
    var deleteEnabled = true

    init(name: String, @ViewBuilder content: () -> Content) {
        self.name = name
        self.content = content()
    }

    init(name: String, buttonsDisabled: Bool, @ViewBuilder content: () -> Content) {
        self.name = name
        if buttonsDisabled {
            infoEnabled = false
            editEnabled = false
            deleteEnabled = false
        }
        self.content = content()
    }

    init(name: String, infoEnabled: Bool, @ViewBuilder content: () -> Content) {
        self.name = name
        self.infoEnabled = infoEnabled
        self.content = content()
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(name)
                    .font(.title2)
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)

            divider()
                .padding(.top, -8)

            content

            if infoEnabled || editEnabled || deleteEnabled {
                divider()
            }

            HStack(spacing: 30) {
                if infoEnabled {
                    Button {
                        performAction(onInfoTab)
                    } label: {
                        Image(systemName: "info.circle")
                            .padding([.leading, .top, .bottom], 5)
                            .foregroundStyle(Color(ComponentColor.lightGreen.rawValue))
                        Text("Info")
                            .padding(.trailing, 10)
                            .foregroundStyle(Color(ComponentColor.lightGreen.rawValue))
                    }
                }

                if editEnabled {
                    Button {
                        performAction(onEditTab)
                    } label: {
                        Image(systemName: "pencil.circle")
                            .padding([.leading, .top, .bottom], 5)
                            .foregroundStyle(Color(ComponentColor.lightBlue.rawValue))

                        Text("Edit")
                            .padding(.trailing, 10)
                            .foregroundStyle(Color(ComponentColor.lightBlue.rawValue))
                    }
                }

                if deleteEnabled {
                    Button {
                        withAnimation {
                            performAction(onDeleteTab)
                        }
                    } label: {
                        Image(systemName: "trash.circle")
                            .padding([.leading, .top, .bottom], 5)
                            .foregroundStyle(.red)
                        Text("Delete")
                            .padding(.trailing, 10)
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.bottom, 7)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
        )
    }

    @ViewBuilder
    private func divider() -> some View {
        Divider()
            .overlay(Color.white)
            .padding([.leading, .trailing])
    }
}

extension LibraryItemBaseView {
    func onInfoTab(_ handler: @escaping () -> Void) -> LibraryItemBaseView {
        var new = self
        new.onInfoTab = handler
        return new
    }

    func onEditTab(_ handler: @escaping () -> Void) -> LibraryItemBaseView {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> LibraryItemBaseView {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}

#Preview {
    LibraryItemBaseView(name: "Name") {
        Text("Test")
    }
}
