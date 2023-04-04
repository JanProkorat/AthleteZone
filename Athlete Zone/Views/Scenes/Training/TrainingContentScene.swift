////
////  TrainingContentScene.swift
////  Athlete Zone
////
////  Created by Jan Prokorát on 23.03.2023.
////
//
// import ComposableArchitecture
// import SwiftUI
//
// struct TrainingContentScene: View {
//    @EnvironmentObject var router: ViewRouter
//    let store: StoreOf<TrainingContentReducer>
//
//    init() {
//        let training = Training()
//        store = Store(
//            initialState: TrainingContentReducer.State(
//                training: .init(training: training),
//                trainingRun: .init()
//            ),
//            reducer: TrainingContentReducer()
//        )
//    }
//
//    var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            switch router.currentTab {
//            case .home:
//                TrainingScene(store: .init(initialState: viewStore.training, reducer: TrainingReducer()))
//
//            default:
//                Text("hello world")
//            }
//        }
//    }
// }
//
// struct TrainingContentScene_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainingContentScene()
//            .environmentObject(ViewRouter())
//    }
// }
