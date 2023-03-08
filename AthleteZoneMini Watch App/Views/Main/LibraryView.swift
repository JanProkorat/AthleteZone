//
//  LibraryView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 09.02.2023.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var isPresented = false

    var body: some View {
        BaseView(title: "Library") {
            VStack {
                List(viewModel.getSortedArray(), id: \._id) { workout in
                    Button {
                        viewModel.setSelectedWorkOut(workout)
                    } label: {
                        ListItemView(name: workout.name, workOutTime: workout.workoutLength.toFormattedTime())
                    }
                    .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2))
                }
                .listStyle(PlainListStyle())
                .environment(\.defaultMinListRowHeight, 50)

                HStack {}
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(ComponentColor.darkBlue.rawValue))
                    .padding(.bottom)
            }
        }
        .sheet(isPresented: $isPresented) {
            Text("test")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    @State static var library: [WorkOut] = [WorkOut(), WorkOut(), WorkOut(), WorkOut()]

    static var previews: some View {
        LibraryView()
            .environmentObject(ViewModel())
    }
}
