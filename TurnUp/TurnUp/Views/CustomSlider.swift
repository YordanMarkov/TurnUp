//
//  CustomSlider.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//
import SwiftUI

struct CustomSlider: View {
    @EnvironmentObject var viewModel: SongViewModel
    let barWidth: CGFloat = 300
    let barHeight: CGFloat = 30
    var isDarkMode: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                // Slider background capsule
                Capsule()
                    .fill(isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3)) // brighter gray in dark mode
                    .frame(width: barWidth, height: barHeight)

                // Slider progress
                Capsule()
                    .fill(isDarkMode
                        ? Color(red: 250/255, green: 172/255, blue: 173/255) // FAACAD
                        : Color(red: 172/255, green: 233/255, blue: 250/255) // ACE9FA
                    )
                    .frame(width: barWidth * viewModel.songProgress, height: barHeight)

                // Slider knob
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .offset(x: barWidth * viewModel.songProgress - 20)
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                let newValue = min(max(0, drag.location.x / barWidth), 1)
                                viewModel.songProgress = newValue
                                viewModel.seek(to: newValue)
                            }
                    )
            }

            // Duration label
            Text(viewModel.currentDurationLabel)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isDarkMode ? .white : .black) // timer color switch
        }
        .padding(.top, 360)
    }
}

