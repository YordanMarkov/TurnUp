//
//  BrightnessObserver.swift
//  TurnUp
//
//  Created by Yordan Markov on 25.03.25.
//

import SwiftUI
import Combine

class BrightnessObserver: ObservableObject {
    @Published var isDarkMode: Bool = UIScreen.main.brightness < 0.3

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(brightnessChanged),
            name: UIScreen.brightnessDidChangeNotification,
            object: nil
        )
        brightnessChanged() 
    }

    @objc private func brightnessChanged() {
        DispatchQueue.main.async {
            self.isDarkMode = UIScreen.main.brightness < 0.3
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
}
