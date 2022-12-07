//
//  MenuBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct MenuBar: View {
    let activeTab: Tab

    var onHomeTab: (() -> Void)?
    var onLibraryTab: (() -> Void)?
    var onProfileTab: (() -> Void)?
    var onSettingsTab: (() -> Void)?

    let icons = [
        MenuBarItem(id: Tab.home, icon: Icons.Home, activeIcon: Icons.HomeActive, activeText: "Home"),
        MenuBarItem(id: Tab.library, icon: Icons.Book, activeIcon: Icons.BookActive, activeText: "Library"),
        MenuBarItem(id: Tab.profile, icon: Icons.Avatar, activeIcon: Icons.AvatarActive, activeText: "Profile"),
        MenuBarItem(id: Tab.setting, icon: Icons.Setting, activeIcon: Icons.SettingActive, activeText: "Settings")
    ]

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(icons) { icon in
                getMenuItem(icon)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(Colors.Menu))
                .frame(height: 70)
                .cornerRadius(35)
                .padding([.leading, .trailing], 10)
        )
    }

    func getMenuItem(_ item: MenuBarItem) -> some View {
        return Group {
            if item.id == self.activeTab {
                SelectedMenuItem(height: 40, icon: item.activeIcon, text: item.activeText)
                    .frame(maxWidth: 110)
            } else {
                IconButton(id: "\(item.id)BarItem", image: item.icon, color: Colors.MenuText, width: 40, height: 40)
                    .onTab {
                        switch item.id {
                        case .home:
                            self.performAction(onHomeTab)

                        case .library:
                            self.performAction(onLibraryTab)

                        case .profile:
                            self.performAction(onProfileTab)

                        case .setting:
                            self.performAction(onSettingsTab)

                        case .exerciseRun:
                            break
                        }
                    }
                    .padding()
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
    let activeText: LocalizedStringKey
}

extension MenuBar {
    func onHomeTab(_ handler: @escaping () -> Void) -> MenuBar {
        var new = self
        new.onHomeTab = handler
        return new
    }

    func onLibraryTab(_ handler: @escaping () -> Void) -> MenuBar {
        var new = self
        new.onLibraryTab = handler
        return new
    }

    func onProfileTab(_ handler: @escaping () -> Void) -> MenuBar {
        var new = self
        new.onProfileTab = handler
        return new
    }

    func onSettingsTab(_ handler: @escaping () -> Void) -> MenuBar {
        var new = self
        new.onSettingsTab = handler
        return new
    }
}
