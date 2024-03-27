//
//  HistoryFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.03.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HistoryFeature {
    @ObservableState
    struct State {
        var library: [StopwatchDto] = []
        var searchText = ""
        var sortOrder: SortOrder = .descending
        var sortBy: StopWatchSortByProperty = .startDate
        var itemForDetail: StopwatchDto?
        var itemForEdit: StopwatchDto?
    }

    enum Action {
        case onAppear
        case searchTextChanged(String)
        case sortByChanged(StopWatchSortByProperty)
        case sortOrderChanged(SortOrder)
        case displayData
        case editTapped(StopwatchDto?)
        case selectTapped(StopwatchDto?)
        case deleteTapped(String)
        case updateActivity(String, String)
    }

    @Dependency(\.stopWatchRealmManager) var realmManager
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.displayData)

            case .searchTextChanged(let text):
                state.searchText = text
                return .send(.displayData)

            case .sortByChanged(let sortBy):
                state.sortBy = sortBy
                return .send(.displayData)

            case .sortOrderChanged(let sortOrder):
                state.sortOrder = sortOrder
                return .send(.displayData)

            case .displayData:
                state.library = realmManager.getSortedData(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .editTapped(let activity):
                state.itemForEdit = activity
                return .none

            case .selectTapped(let activity):
                state.itemForDetail = activity
                return .none

            case .deleteTapped(let id):
                realmManager.delete(entityId: id)
                return .send(.displayData)

            case .updateActivity(let id, let name):
                realmManager.update(id, name)
                return .run { send in
                    await send(.editTapped(nil))
                    await send(.displayData)
                }
            }
        }
    }
}
