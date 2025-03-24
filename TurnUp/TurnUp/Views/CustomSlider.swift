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

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: barWidth, height: barHeight)

                Capsule()
                    .fill(Color(red: 172/255, green: 233/255, blue: 250/255)) // #ACE9FA
                    .frame(width: barWidth * viewModel.songProgress, height: barHeight)

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

            Text(viewModel.currentDurationLabel)
                .font(.system(size: 18, weight: .bold))
        }
        .padding(.top, 360)
    }
}
