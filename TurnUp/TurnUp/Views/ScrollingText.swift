//
//  ScrollingText.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//

import SwiftUI

struct ScrollingText: View {
    let text: String
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let width: CGFloat
    let height: CGFloat
    let speed: Double = 20.0 // higher = slower

    @State private var textOffset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var startAnimation = false

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text(text)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    textWidth = geo.size.width
                                    textOffset = 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        startMarquee()
                                    }
                                }
                        }
                    )
                    .offset(x: textOffset)
                if textWidth > width {
                    Text(text)
                        .font(.system(size: fontSize, weight: fontWeight))
                        .offset(x: textOffset + textWidth + 40)
                }
            }
        }
        .frame(width: width, height: height, alignment: .leading)
        .clipped()
    }

    private func startMarquee() {
        guard textWidth > width else { return }

        let totalDistance = textWidth + 40
        let duration = Double(totalDistance) / speed

        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
            textOffset = -totalDistance
        }
    }
}
#Preview {
    VStack(spacing: 20) {
        ScrollingText(
            text: "Short title",
            fontSize: 20,
            fontWeight: .bold,
            width: 300,
            height: 30
        )

        ScrollingText(
            text: "🚗 This is a long long long song title that will finally scroll like a car's music app should",
            fontSize: 20,
            fontWeight: .bold,
            width: 300,
            height: 30
        )
    }
    .padding()
}
