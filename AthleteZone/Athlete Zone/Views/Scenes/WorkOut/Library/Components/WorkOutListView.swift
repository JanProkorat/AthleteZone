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
                        .padding(.leading, 10)
                    Menu {
                        Button(action: {
                            performAction(onEditTab)
                        }, label: {
                            Label(LocalizationKey.edit.localizedKey, systemImage: "pencil")
                        })

                        Button(role: .destructive, action: {
                            performAction(onDeleteTab)
                        }, label: {
                            Label(LocalizationKey.delete.localizedKey, systemImage: "trash")
                        })
                    } label: {
                        Image(Icons.menu.rawValue)
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                            .frame(width: 40, height: 34)
                            .padding(.trailing, 10)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)

                ForEach(fieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        listViewItem(item: chunk.first!, width: reader.size.width * 0.8 * 0.5)
                        listViewItem(item: chunk.count > 1 ? chunk.last! : nil, width: reader.size.width * 0.9 * 0.5)
                    }
                    .padding(.bottom, chunk.count > 1 ? 1 : 10)
                    .frame(maxWidth: reader.size.width * 0.9, alignment: .center)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            )
        }
    }

    @ViewBuilder
    func listViewItem(item: ActivityType?, width: CGFloat) -> some View {
        HStack {
            Text(item == nil ? LocalizationKey.total.localizedKey : LocalizedStringKey(item!.rawValue))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .scaledToFill()
            Text(":")
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .padding(.leading, -7)
            Text(item == nil ? self.workOut.workoutLength.toFormattedTime() : getValueByType(item!))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
        }
        .frame(width: width, alignment: .leading)
    }

    private func getColor(_ type: ActivityType?) -> String {
        switch type {
        case .work:
            return ComponentColor.lightPink.rawValue

        case .rest:
            return ComponentColor.lightYellow.rawValue

        case .series:
            return ComponentColor.lightBlue.rawValue

        case .rounds:
            return ComponentColor.lightGreen.rawValue

        case .reset:
            return ComponentColor.braun.rawValue

        default:
            return ComponentColor.mainText.rawValue
        }
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
