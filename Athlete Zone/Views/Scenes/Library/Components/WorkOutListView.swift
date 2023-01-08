//
//  WorkOutListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.11.2022.
//

import SwiftUI

struct WorkOutListView: View {
    let workOut: WorkOut

    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?

    let fieldConfig: [[ActivityType]] = [.work, .rounds, .rest, .series, .reset].chunked(into: 2)

    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack(alignment: .center) {
                    TitleText(text: workOut.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    Menu {
                        Button(action: {
                            performAction(onEditTab)
                        }, label: {
                            Label(LocalizedStringKey("Edit"), systemImage: "pencil")
                        })

                        Button(role: .destructive, action: {
                            performAction(onDeleteTab)
                        }, label: {
                            Label(LocalizedStringKey("Delete"), systemImage: "trash")
                        })
                    } label: {
                        Image(Icons.Menu)
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                            .frame(width: 40, height: 34)
                            .padding(.trailing, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)

                ForEach(fieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        listViewItem(item: chunk.first!, width: reader.size.width * 0.8 * 0.5)
                        listViewItem(item: chunk.count > 1 ? chunk.last! : nil, width: reader.size.width * 0.8 * 0.4)
                    }
                    .padding(.bottom, chunk.count > 1 ? 1 : 10)
                    .frame(maxWidth: reader.size.width * 0.8, alignment: .leading)
                }

//                listViewItem(
//                    text: "Created:",
//                    value: workOut.formattedCreatedDate,
//                    color: ComponentColor.mainText,
//                    width: reader.size.width * 0.7
//                )
//                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(Background.work.rawValue))
            )
        }
    }

    @ViewBuilder
    func listViewItem(item: ActivityType?, width: CGFloat) -> some View {
        HStack {
            ListViewText(
                text: item == nil ? "Total:" : "\(item!.rawValue):",
                color: item == nil ? ComponentColor.mainText :
                    ComponentColor.allCases.first(where: { $0.rawValue == item!.rawValue })!
            )
            ListViewText(
                text: item == nil ? self.workOut.timeOverview.toFormattedTime() : getValueByType(item!),
                color: item == nil ? ComponentColor.mainText :
                    ComponentColor.allCases.first(where: { $0.rawValue == item!.rawValue })!
            )
        }
        .frame(width: width, alignment: .leading)
    }

    @ViewBuilder
    func listViewItem(text: String, value: String, color: ComponentColor, width: CGFloat) -> some View {
        HStack {
            ListViewText(
                text: text,
                color: color
            )

            ListViewText(
                text: value,
                color: color
            )
        }
        .frame(width: width, alignment: .center)
    }

    func getValueByType(_ type: ActivityType) -> String {
        switch type {
        case .work:
            return workOut.work.toFormattedTime()

        case .rest:
            return workOut.rest.toFormattedTime()

        case .series:
            return workOut.series.toFormattedValue(type: .number)

        case .rounds:
            return workOut.rounds.toFormattedValue(type: .number)

        case .reset:
            return workOut.reset.toFormattedTime()
        }
    }
}

struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(workOut: WorkOut())
    }
}

extension WorkOutListView {
    func onEditTab(_ handler: @escaping () -> Void) -> WorkOutListView {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> WorkOutListView {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}
