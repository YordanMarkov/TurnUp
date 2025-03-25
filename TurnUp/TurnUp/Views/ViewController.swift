//
//  UIViewController.swift
//  TurnUp
//
//  Created by User on 25/03/2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Set initial theme based on brightness
        checkBrightnessAndSetTheme()

        // Keep watching for brightness changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(brightnessDidChange),
            name: UIScreen.brightnessDidChangeNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkBrightnessAndSetTheme()
    }

    private func checkBrightnessAndSetTheme() {
        let brightness = UIScreen.main.brightness
        print("Current screen brightness: \(brightness)")

        if brightness < 0.3 {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

    @objc private func brightnessDidChange() {
        checkBrightnessAndSetTheme()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
}
