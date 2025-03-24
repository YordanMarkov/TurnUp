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
    @State private var ready = false

    var body: some View {
        ZStack {
            if ready && textWidth > width {
                HStack(spacing: 40) {
                    Text(text)
                    Text(text)
                }
                .font(.system(size: fontSize, weight: fontWeight))
                .offset(x: animate ? -textWidth - 40 : 0)
                .onAppear {
                    animate = true
                }
                .animation(
                    .linear(duration: Double(textWidth) / 30)
                        .repeatForever(autoreverses: false),
                    value: animate
                )
                .frame(width: width, alignment: .leading)
                .clipped()
            } else if ready {
                Text(text)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: width, height: height, alignment: .center)
            }
        }
        .frame(width: width, height: height)
        .overlay(
            Text(text)
                .font(.system(size: fontSize, weight: fontWeight))
                .fixedSize()
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            textWidth = geo.size.width
                            ready = true
                        }
                    }
                )
                .hidden()
        )
    }
}
