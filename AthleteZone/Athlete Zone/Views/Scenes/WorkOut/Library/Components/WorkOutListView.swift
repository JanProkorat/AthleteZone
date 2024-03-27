//
//  WorkOutListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.11.2022.
//

import SwiftUI

struct WorkOutListView: View {
    var workOut: WorkoutDto
    var buttonsEnabled = true

    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?
    var onSelectTab: (() -> Void)?

    let fieldConfig: [[ActivityType]] = [.work, .series, .rest, .rounds, .reset].chunked(into: 2)

    init(workOut: WorkoutDto) {
        self.workOut = workOut
    }

    init(workOut: WorkoutDto, buttonsEnabled: Bool) {
        self.workOut = workOut
        self.buttonsEnabled = buttonsEnabled
    }

    var body: some View {
        GeometryReader { reader in
            Button {
                performAction(onSelectTab)
            } label: {
                if buttonsEnabled {
                    view(width: reader.size.width)
                } else {
                    viewWithoutButtons(width: reader.size.width)
                }
            }
            .padding(.bottom, 10)
            .background(Color(ComponentColor.darkBlue.rawValue))
        }
    }

    @ViewBuilder
    func view(width: CGFloat) -> some View {
        LibraryItemBaseView(name: workOut.name, infoEnabled: false) {
            VStack {
                ForEach(fieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        listViewItem(item: chunk.first!, width: width * 0.4)
                            .padding(.leading)
                            .padding(.trailing, 4)
                        listViewItem(
                            item: chunk.count > 1 ? chunk.last! : nil, width: width * 0.4
                        )
                        .padding(.leading, 4)
                        .padding(.trailing)
                    }
                    .padding(.bottom, chunk.count > 1 ? 1 : 10)
                    .frame(alignment: .center)
                }
            }
            .padding(.top, -10)
            .padding(.bottom, -10)
        }
        .onEditTab { performAction(onEditTab) }
        .onDeleteTab { performAction(onDeleteTab) }
    }

    @ViewBuilder
    func viewWithoutButtons(width: CGFloat) -> some View {
        LibraryItemBaseView(name: workOut.name, buttonsDisabled: true) {
            VStack {
                ForEach(fieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        listViewItem(item: chunk.first!, width: width * 0.4)
                            .padding(.leading)
                            .padding(.trailing, 4)
                        listViewItem(
                            item: chunk.count > 1 ? chunk.last! : nil, width: width * 0.4
                        )
                        .padding(.leading, 4)
                        .padding(.trailing)
                    }
                    .padding(.bottom, chunk.count > 1 ? 1 : 10)
                    .frame(alignment: .center)
                }
            }
            .padding(.top, -10)
            .padding(.bottom, -10)
        }
    }

    @ViewBuilder
    func listViewItem(item: ActivityType?, width: CGFloat) -> some View {
        HStack {
            Text(item == nil ? LocalizationKey.total.localizedKey : LocalizedStringKey(item!.rawValue))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
            Text(":")
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .padding(.leading, -7)
            Text(item == nil ? self.workOut.workoutLength.toFormattedTime() : getValueByType(item!))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .frame(maxWidth: .infinity, alignment: .trailing)
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
        WorkOutListView(
            workOut:
            WorkoutDto(
                id: "1",
                name: "asdas",
                work: 5,
                rest: 5,
                series: 5,
                rounds: 5,
                reset: 5,
                createdDate: Date(),
                workoutLength: 180
            )
        )
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

    func onSelectTab(_ handler: @escaping () -> Void) -> WorkOutListView {
        var new = self
        new.onSelectTab = handler
        return new
    }
}
