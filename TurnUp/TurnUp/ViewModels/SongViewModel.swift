//
//  SongViewModel.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//

import Foundation
import AVFoundation
import Combine

class SongViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var currentTime: String = ""
    @Published var currentSongIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var currentSong: Song
    @Published var songProgress: Double = 0.0 // from 0.0 to 1.0
    @Published var currentDurationLabel: String = "0:00"

    private var timer: AnyCancellable?
    private var timeUpdater: AnyCancellable?
    private var player: AVAudioPlayer?

    let songs: [Song] = [
        Song(name: "GPS-A", artist: "Lidia, Dessita & Tedi Aleksandrova", fileName: "GPS-A", imageName: "GPSPic"),
        Song(name: "Neudobni vaprosi", artist: "Galena & Gamzata", fileName: "Neudobni", imageName: "NeudobniPic"),
        Song(name: "Draskai klechkata", artist: "Tsvetelina Yaneva", fileName: "Draskai", imageName: "DraskaiPic")
    ]

    override init() {
        currentSong = songs[0]
        super.init()
        updateTime()
        startClockTimer()
        loadAndPlayCurrentSong()
    }

    private func startClockTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }

    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: Date())
    }

    private func startPlaybackTimer() {
        timeUpdater = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.player else { return }
                self.songProgress = player.duration > 0 ? player.currentTime / player.duration : 0
                self.currentDurationLabel = self.formatTime(player.currentTime)
            }
    }

    func loadAndPlayCurrentSong() {
        timeUpdater?.cancel()

        guard let url = Bundle.main.url(forResource: currentSong.fileName, withExtension: "mp3") else {
            print("Song not found: \(currentSong.fileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self // ✅ SET THE DELEGATE HERE
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            startPlaybackTimer()
        } catch {
            print("Failed to load song: \(error)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextSong()
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func nextSong() {
        currentSongIndex = (currentSongIndex + 1) % songs.count
        currentSong = songs[currentSongIndex]
        loadAndPlayCurrentSong()
    }

    func previousSong() {
        currentSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
        currentSong = songs[currentSongIndex]
        loadAndPlayCurrentSong()
    }

    func seek(to progress: Double) {
        guard let player = player else { return }
        player.currentTime = player.duration * progress
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
