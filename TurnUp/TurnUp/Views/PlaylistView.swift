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
        VStack(spacing: 10) {
            Text(viewModel.currentPlaylist.name)
                .font(.largeTitle.bold())
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.top, 12)

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

                                Text(song.artist)
                                    .font(.title2)
                                    .foregroundColor(isDarkMode ? .white.opacity(0.7) : .secondary)
                            }

                            Spacer()

                            if viewModel.currentSongIndex == index && viewModel.currentPlaylist.id == viewModel.selectedPlaylistIndex {
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
                .padding(.vertical, 10)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture().onEnded { value in
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
