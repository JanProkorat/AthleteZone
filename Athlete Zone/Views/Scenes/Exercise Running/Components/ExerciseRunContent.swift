//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunContent: View {
    
    @State private var isRunning = true
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @StateObject private var viewModel: WorkFlowViewModel
    
    init(workOut: WorkOut){
        _viewModel = StateObject(wrappedValue: WorkFlowViewModel(workOut: workOut))
    }
    
    var onQuitTab: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let flow = self.viewModel.selectedFlow {
                DescriptionLabel(title: "Round \(flow.round)/\(self.viewModel.roundsCount)", color: Colors.Rounds)
                DescriptionLabel(title: "Exercise \(flow.serie)/\(self.viewModel.seriesCount)", color: Colors.Series)
                
                Text("\(flow.type.rawValue)")
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ZStack{
                            CircularProgressBar(color: flow.type == .work ? Colors.Pink : flow.type == .rest ? Colors.Yellow : Colors.Braun, progress: flow.getProgress())
                            CounterText(text: flow.interval.toFormattedTime(), size: geometry.size.height * 0.14)
                        }
                        HStack(alignment: .center){
                            IconButton(id: "start", image: isRunning ? Icons.Actions_pause : Icons.Start, color: Colors.Action, width: geometry.size.height * 0.3, height: geometry.size.height * 0.3)
                                .onTab{
                                    isRunning = !isRunning
                                }
                            IconButton(id: "forward", image: Icons.Actions_forward, color: Colors.Action, width: geometry.size.height * 0.26, height: geometry.size.height * 0.26)
                                .onTab{
                                    self.viewModel.selectedFlowIndex += 1
                                }
                        }
                        
                        VStack{
                            if self.viewModel.selectedFlowIndex > 0 || !self.isRunning {
                                Button {
                                    if !isRunning {
                                        if self.onQuitTab != nil{
                                            self.onQuitTab!();
                                        }
                                    }else {
                                        self.viewModel.selectedFlowIndex -= 1
                                    }
                                } label: {
                                    Text(isRunning ? "Previous exercise" : "Quit exercise")
                                        .font(.custom("Lato-ThinItalic", size: 20))
                                        .bold()
                                }
                                .padding(.top, 10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(Color(Colors.MainText))
                            }
                        }
                        .frame(height: 20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            if self.viewModel.selectedFlow != nil {
                if self.viewModel.selectedFlow!.interval > 0 {
                    self.viewModel.selectedFlow!.setInterval(self.viewModel.selectedFlow!.interval - 1)
                }else{
                    self.viewModel.selectedFlowIndex += 1
                }
            }
        }
        .onChange(of: self.viewModel.selectedFlowIndex) { newValue in
            if self.viewModel.selectedFlowIndex < self.viewModel.flow.count {
                self.viewModel.selectedFlow = self.viewModel.flow[self.viewModel.selectedFlowIndex]
            }else{
                if self.onQuitTab != nil{
                    self.onQuitTab!()
                }
            }
        }
        .onChange(of: self.isRunning) { newValue in
            if !self.isRunning {
                self.timer.upstream.connect().cancel()
            }else{
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }
        
    }
}

struct ExerciseRunContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunContent(workOut: WorkOut())
    }
}

extension ExerciseRunContent{
    func onQuitTab(_ handler: @escaping () -> Void) -> ExerciseRunContent {
        var new = self
        new.onQuitTab = handler
        return new
    }
}


