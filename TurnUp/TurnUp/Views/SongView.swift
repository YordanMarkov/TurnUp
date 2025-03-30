//
//  SongView.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//

import SwiftUI

public struct SongView: View {
    @StateObject private var viewModel = SongViewModel()
    @State private var showPlaylist = false
    @StateObject private var brightnessObserver = BrightnessObserver()

    public var body: some View {
        ZStack {
            Image(brightnessObserver.isDarkMode ? "Background-dark" : "Background-light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)

            Text(viewModel.currentTime)
                .foregroundColor(brightnessObserver.isDarkMode ? .white : .black)
                .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)
                .bold()
                .font(.system(size: 90, weight: .bold, design: .default))
                .padding(.top, -400)

            if showPlaylist {
                PlaylistView(showPlaylist: $showPlaylist, isDarkMode: brightnessObserver.isDarkMode)
                    .environmentObject(viewModel)
                    .padding(.top, 150)
                    .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)
            } else {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 350, height: 500)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)

                Image(viewModel.currentSong.imageName)
                    .resizable()
                    .frame(width: 270, height: 270)
                    .cornerRadius(20)
                    .padding(.top, -150)
                    .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)

                ScrollingText(
                    text: viewModel.currentSong.artist,
                    fontSize: 15,
                    fontWeight: .bold,
                    width: 300,
                    height: 50
                )
                .foregroundColor(brightnessObserver.isDarkMode ? .white : .black)
                .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)
                .padding(.top, 170)
                .id("artist-\(viewModel.currentSong.artist)")

                ScrollingText(
                    text: viewModel.currentSong.name,
                    fontSize: 48,
                    fontWeight: .bold,
                    width: 300,
                    height: 50
                )
                .foregroundColor(brightnessObserver.isDarkMode ? .white : .black)
                .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)
                .padding(.top, 260)
                .id("title-\(viewModel.currentSong.name)")

                CustomSlider(isDarkMode: brightnessObserver.isDarkMode)
                    .environmentObject(viewModel)
                    .padding(.top, 50)
                    .animation(.easeInOut(duration: 0.4), value: brightnessObserver.isDarkMode)
                
                Button(action: {
                    withAnimation {
                        showPlaylist = true
                    }
                }) {
                    Image(brightnessObserver.isDarkMode ? "dark arrow" : "Arrow")
                        .rotationEffect(.degrees(180))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 670)
            }

            if let message = viewModel.statusMessage {
                ZStack {
                    VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                        .ignoresSafeArea()
                        .opacity(0.8)
                        .transition(.opacity)

                    Text(message)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 20)
                        .background(
                            Color.white
                                .opacity(0.95)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        )
                        .shadow(radius: 20)
                        .scaleEffect(1.0)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 1.1).combined(with: .opacity)
                        ))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            TapGesture().onEnded {
                viewModel.togglePlayPause()
            }
        )
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height < -50 {
                    withAnimation {
                        showPlaylist = true
                    }
                } else if value.translation.height > 50 {
                    withAnimation {
                        showPlaylist = false
                    }
                } else if value.translation.width < -50 {
                    viewModel.nextSong()
                } else if value.translation.width > 50 {
                    viewModel.previousSong()
                }
            }
        )
        .onAppear {
            viewModel.startListening()
        }
    }
}

#Preview {
    SongView()
}
