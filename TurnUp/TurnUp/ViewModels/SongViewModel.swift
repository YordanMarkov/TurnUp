//
//  SongViewModel.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//

import Foundation
import Combine

class SongViewModel: ObservableObject {
    @Published var currentTime: String = ""

    private var timer: AnyCancellable?

    init() {
        updateTime()
        startTimer()
    }

    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: Date())
    }

    private func startTimer() {
        // Updates the time every minute
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }

    deinit {
        timer?.cancel()
    }
}
