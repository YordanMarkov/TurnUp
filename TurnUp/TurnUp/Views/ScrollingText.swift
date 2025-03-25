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

    @State private var textWidth: CGFloat = 0
    @State private var animate = false
    @State private var currentText: String = ""

    var body: some View {
        ZStack {
            if textWidth > width {
                GeometryReader { geo in
                    let totalWidth = textWidth + 40
                    HStack(spacing: 40) {
                        Text(text)
                            .font(.system(size: fontSize, weight: fontWeight))
                            .fixedSize()
                        Text(text)
                            .font(.system(size: fontSize, weight: fontWeight))
                            .fixedSize()
                    }
                    .offset(x: animate ? -totalWidth : 0)
                    .onAppear {
                        startAnimationWithDelay()
                    }
                }
            } else {
                Text(text)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .background(
            Text(text)
                .font(.system(size: fontSize, weight: fontWeight))
                .fixedSize()
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                textWidth = geo.size.width
                                currentText = text
                                startAnimationWithDelay()
                            }
                    }
                )
                .hidden()
        )
        .onChange(of: text) {
            animate = false
            textWidth = 0
            currentText = text
        }
    }

    private func startAnimationWithDelay() {
        if textWidth > width {
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(
                    Animation.linear(duration: Double(textWidth + 40) / 30)
                        .repeatForever(autoreverses: false)
                ) {
                    animate = true
                }
            }
        }
    }
}
