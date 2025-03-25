//
//  PlaylistsView.swift
//  TurnUp
//
//  Created by Kalina on 25/03/2025.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var viewModel: SongViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Image("Background-light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Up Next")
                    .font(.largeTitle.bold())
                    .padding(.top, 60)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.songs.indices, id: \.self) { index in
                            let song = viewModel.songs[index]
                            HStack {
                                Image(song.imageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)

                                VStack(alignment: .leading) {
                                    Text(song.name)
                                        .font(.headline)
                                    Text(song.artist)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                if index == viewModel.currentSongIndex {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            .onTapGesture {
                                viewModel.currentSongIndex = index
                                viewModel.currentSong = song
                                viewModel.loadAndPlayCurrentSong()
                                dismiss()
                            }
                        }
                    }
                    .padding()
                }

                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        dismiss()
                    }
                }
        )
    }
}
