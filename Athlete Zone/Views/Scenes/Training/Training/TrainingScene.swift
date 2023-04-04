//
//  TrainingScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

// import ComposableArchitecture
import SwiftUI

// struct TrainingScene: View {
//    @EnvironmentObject var router: ViewRouter
//    let store: StoreOf<TrainingReducer>
//
//    var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            BaseView {
//                TrainingHeader(name: viewStore.training.name)
//            } content: {
//                TrainingContent(training: viewStore.training)
//                    .onStartTab {
//                    }
//            } footer: {
//                MenuBar(activeTab: router.currentTab)
//                    .onRouteTab { router.currentTab = $0 }
//            }
//        }
//    }
// }
//
// struct TrainingScene_Previews: PreviewProvider {
//    static var previews: some View {
//        let store = Store(initialState: TrainingReducer.State(training: Training()), reducer: TrainingReducer())
//        TrainingScene(store: store)
//            .environmentObject(ViewRouter())
//    }
// }
