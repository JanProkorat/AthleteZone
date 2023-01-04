//
//  MenuBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct MenuBar: View {
    let activeTab: Tab

    var onRouteTab: ((_ routeToGo: Tab) -> Void)?

    let icons = [
        MenuBarItem(id: Tab.home, icon: Icons.Home, activeIcon: Icons.HomeActive),
        MenuBarItem(id: Tab.library, icon: Icons.Book, activeIcon: Icons.BookActive),
        //        MenuBarItem(id: Tab.profile, icon: Icons.Avatar, activeIcon: Icons.AvatarActive, activeText: "Profile"),
        MenuBarItem(id: Tab.setting, icon: Icons.Setting, activeIcon: Icons.SettingActive)
    ]

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(icons) { item in
                RoundedRectangle(cornerRadius: 20)
                    .overlay(
                        Button(action: {
                            self.performAction(onRouteTab, value: item.id)
                        }, label: {
                            Image(item.id == activeTab ? item.activeIcon : item.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(item.id == activeTab ? ComponentColor.darkBlue.rawValue
                                        : ComponentColor.menuText.rawValue))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(item.id == activeTab ? ComponentColor.action.rawValue : ""),
                                                lineWidth: 0)
                                        .frame(width: 40, height: 40)
                                )

                        })
                        .frame(width: 40, height: 40)
                    )
                    .foregroundColor(Color(item.id == activeTab ? ComponentColor.menuItemSelected.rawValue : ""))
                    .frame(
                        maxHeight: 40 + 10,
                        alignment: .center
                    )
                    .cornerRadius(35)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 35)
                .foregroundColor(Color(ComponentColor.menu.rawValue))
                .frame(maxHeight: 70)
        )
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
