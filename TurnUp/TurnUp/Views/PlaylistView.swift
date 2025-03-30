//
//  PlaylistView.swift
//  TurnUp
//
//  Created by Kalina on 25/03/2025.
//

import SwiftUI

public struct PlaylistView: View {
    @EnvironmentObject var viewModel: SongViewModel
    @Binding var showPlaylist: Bool
    var isDarkMode: Bool = false

    public var body: some View {
        VStack(spacing: 0) {
            // Fixed Header with Playlist Name and Navigation
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.previousPlaylist()
                    }
                }) {
                    Image(isDarkMode ? "dark arrow" : "Arrow")
                        .rotationEffect(.degrees(90))
                }
                .buttonStyle(ArrowButtonStyle())

                Spacer()

                Text(viewModel.currentPlaylist.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(isDarkMode ? .white : .black)
                    .animation(.easeInOut(duration: 0.4), value: isDarkMode)
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: {
                    withAnimation {
                        viewModel.nextPlaylist()
                    }
                }) {
                    Image(isDarkMode ? "dark arrow" : "Arrow")
                        .rotationEffect(.degrees(-90))
                }
                .buttonStyle(ArrowButtonStyle())
            }
            .padding(.top, 40)
            .padding(.bottom, 20)

            // Scrollable Songs List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.currentPlaylist.songs.indices, id: \.self) { index in
                        let song = viewModel.currentPlaylist.songs[index]

                        HStack {
                            Image(song.imageName)
                                .resizable()
                                .frame(width: 110, height: 110)
                                .cornerRadius(20)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(song.name)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .animation(.easeInOut(duration: 0.4), value: isDarkMode)

                                Text(song.artist)
                                    .font(.title2)
                                    .foregroundColor(isDarkMode ? .white.opacity(0.7) : .secondary)
                                    .animation(.easeInOut(duration: 0.4), value: isDarkMode)
                            }

                            Spacer()

                            if viewModel.currentSongIndex == index &&
                                viewModel.currentPlaylist.id == viewModel.selectedPlaylistIndex {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .onTapGesture {
                            viewModel.selectedPlaylistIndex = viewModel.currentPlaylist.id
                            viewModel.currentSongIndex = index
                            viewModel.currentSong = song
                            viewModel.loadAndPlayCurrentSong()
                            withAnimation {
                                showPlaylist = false
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < -50 {
                        withAnimation {
                            viewModel.nextPlaylist()
                        }
                    } else if value.translation.width > 50 {
                        withAnimation {
                            viewModel.previousPlaylist()
                        }
                    }
                }
        )
    }
}

// MARK: - Custom Button Style for Tap Feedback

struct ArrowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
