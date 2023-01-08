//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import AVKit
import SwiftUI

struct WorkOutRunContent: View {
    @AppStorage(DefaultItem.soundsEnabled.rawValue) private var soundsEnabled = true
    @EnvironmentObject var viewModel: WorkFlowViewModel

    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var state: WorkFlowState = .running

    var onQuitTab: (() -> Void)?
    var onIsRunningChange: (() -> Void)?

    @State var player: AVAudioPlayer?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let flow = self.viewModel.selectedFlow {
                DescriptionLabel(title: "Round \(flow.round)/\(self.viewModel.roundsCount)",
                                 color: ComponentColor.rounds)
                DescriptionLabel(title: "Exercise \(flow.serie)/\(self.viewModel.seriesCount)",
                                 color: ComponentColor.series)

                Text(LocalizedStringKey(flow.type.rawValue))
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)

                GeometryReader { geo in
                    VStack(spacing: 0) {
                        ZStack {
                            CircularProgressBar(color: flow.color, progress: flow.getProgress())
                            CounterText(text: flow.interval.toFormattedTime(), size: geo.size.height * 0.14)
                        }
                        .frame(maxWidth: .infinity)

                        HStack(alignment: .center) {
                            IconButton(
                                id: "start",
                                image: state == .running ? Icons.ActionsPause : Icons.Start,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.3,
                                height: geo.size.height * 0.3
                            )
                            .onTab {
                                if state == .finished {
                                    viewModel.selectedFlowIndex = 0
                                }
                                state = state == .running ? .paused : .running
                                performAction(self.onIsRunningChange)
                            }
                            IconButton(
                                id: "forward",
                                image: Icons.ActionsForward,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.26,
                                height: geo.size.height * 0.26
                            )
                            .onTab {
                                if !viewModel.isLastRunning {
                                    self.viewModel.selectedFlowIndex += 1
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            if self.viewModel.selectedFlow != nil {
                if self.viewModel.selectedFlow!.interval > 1 {
                    self.viewModel.selectedFlow!.interval -= 1
                    if self.viewModel.selectedFlow!.interval <= 3 &&
                        self.viewModel.selectedFlow!.interval > 0 &&
                        soundsEnabled
                    {
                        playSound(sound: .beep)
                    }
                } else {
                    if soundsEnabled {
                        playSound(sound: self.viewModel.isLastRunning ? .fanfare : .gong)
                    }
                    if self.viewModel.isLastRunning {
                        self.viewModel.selectedFlow!.interval -= 1
                    }
                    self.viewModel.selectedFlowIndex += 1
                }
            }
        }
        .onChange(of: self.viewModel.selectedFlowIndex) { _ in
            if self.viewModel.selectedFlowIndex < self.viewModel.flow.count {
                self.viewModel.selectedFlow = self.viewModel.flow[self.viewModel.selectedFlowIndex]
            } else {
                state = .finished
            }
        }
        .onChange(of: state) { _ in
            if state != .running {
                self.timer.upstream.connect().cancel()
            } else {
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }
    }
}

struct WorkOutRunContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunContent(state: .running)
            .environmentObject(WorkFlowViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel(selectedWorkOut: WorkOut()))
    }
}

extension WorkOutRunContent {
    func onQuitTab(_ handler: @escaping () -> Void) -> WorkOutRunContent {
        var new = self
        new.onQuitTab = handler
        return new
    }

    func onIsRunningChange(_ handler: @escaping () -> Void) -> WorkOutRunContent {
        var new = self
        new.onIsRunningChange = handler
        return new
    }

    func playSound(sound: Sound) {
        if let asset = NSDataAsset(name: sound.rawValue) {
            do {
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
                player?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
