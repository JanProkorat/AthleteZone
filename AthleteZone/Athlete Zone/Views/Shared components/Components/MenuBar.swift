//
//  MenuBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct MenuBar: View {
    @Environment(\.footerSize) var footerHeight: CGFloat

    let activeTab: Tab

    var onRouteTab: ((_ routeToGo: Tab) -> Void)?

    let icons = [
        MenuBarItem(id: Tab.home, icon: Icon.home.rawValue, activeIcon: Icon.homeActive.rawValue),
        MenuBarItem(id: Tab.library, icon: Icon.book.rawValue, activeIcon: Icon.bookActive.rawValue),
        MenuBarItem(id: Tab.settings, icon: Icon.setting.rawValue, activeIcon: Icon.settingActive.rawValue)
    ]

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            HStack {
                ForEach(icons) { item in
                    Button {
                        withAnimation {
                            self.performAction(onRouteTab, value: item.id)
                        }
                    } label: {
                        Image(item.id == activeTab ? item.activeIcon : item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: footerHeight * 0.5, maxHeight: footerHeight * 0.5)
                            .foregroundStyle(Color(item.id == activeTab ?
                                    ComponentColor.darkBlue.rawValue
                                    : ComponentColor.menuText.rawValue))
                            .padding([.top, .bottom], 5)
                    }
                    .frame(maxWidth: .infinity)
                    .roundedBackground(cornerRadius: 30, color: item.id == activeTab ? ComponentColor.menuItemSelected : ComponentColor.menu)
                }
            }
            .padding([.leading, .trailing])
        }
        .frame(maxWidth: .infinity, maxHeight: footerHeight)
        .roundedBackground(cornerRadius: 30, color: ComponentColor.menu)
    }

    func getMenuItem(_ item: MenuBarItem) -> some View {
        return Group {
            if item.id == self.activeTab {
                SelectedMenuItem(height: 40, icon: item.activeIcon)
            } else {
                IconButton(id: "\(item.id)BarItem", image: item.icon,
                           color: ComponentColor.menuText, width: 40, height: 40)
                    .onTab { self.performAction(onRouteTab, value: item.id) }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBar(activeTab: Tab.library)
            .environment(\.footerSize, 50)
    }
}

struct MenuBarItem: Identifiable {
    let id: Tab
    let icon: String
    let activeIcon: String
}

extension MenuBar {
    func onRouteTab(_ handler: @escaping (_ routeToGo: Tab) -> Void) -> MenuBar {
        var new = self
        new.onRouteTab = handler
        return new
    }
}
