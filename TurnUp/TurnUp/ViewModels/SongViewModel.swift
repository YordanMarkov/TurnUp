// Updated SongViewModel: auto-cancel if no song/playlist is detected within 5 seconds

import Foundation
import AVFoundation
import Combine
import SwiftUI
import Speech

struct Playlist {
    let id: Int
    let name: String
    let songs: [Song]
}

class SongViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var currentTime: String = ""
    @Published var currentSongIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var currentSong: Song
    @Published var songProgress: Double = 0.0
    @Published var currentDurationLabel: String = "0:00"
    @Published var statusMessage: String? = nil
    @Published var selectedPlaylistIndex: Int = 1

    private var timer: AnyCancellable?
    private var timeUpdater: AnyCancellable?
    private var player: AVAudioPlayer?

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var isListeningForTitle = false
    private var collectedTitleWords: [String] = []
    private var titleListeningTimer: Timer?

    private(set) var playlists: [Playlist] = [
        Playlist(id: 0, name: "Welcome to Bulgaria", songs: [
            Song(name: "GPS-A", artist: "Lidia, Dessita & Tedi Aleksandrova", fileName: "GPS-A", imageName: "GPSPic"),
            Song(name: "Neudobni vaprosi", artist: "Galena & Gamzata", fileName: "Neudobni", imageName: "NeudobniPic"),
            Song(name: "Draskai klechkata", artist: "Tsvetelina Yaneva", fileName: "Draskai", imageName: "DraskaiPic")
        ]),
        Playlist(id: 1, name: "Favorite Pop", songs: [
            Song(name: "Espresso", artist: "Sabrina Carpenter", fileName: "espresso", imageName: "sabrina"),
            Song(name: "Side to side", artist: "Ariana Grande, Nicki Minaj", fileName: "side", imageName: "ariana"),
            Song(name: "LUNCH", artist: "Billie Eilish", fileName: "lunch", imageName: "chihiro")
        ])
    ]

    private let secretPlaylist = Playlist(id: 99, name: "Party Mode 🎉", songs: [
        Song(name: "Fireball", artist: "Pitbull, John Ryan", fileName: "fireball", imageName: "fireball"),
        Song(name: "Gasolina", artist: "Daddy Yankee", fileName: "gasolina", imageName: "gasolina"),
        Song(name: "Rock this party", artist: "Bob Sinclar", fileName: "rock", imageName: "rock")
    ])

    override init() {
        currentSong = playlists[1].songs[0]
        super.init()
        updateTime()
        startClockTimer()
        loadAndPlayCurrentSong()
    }

    var currentPlaylist: Playlist {
        playlists[selectedPlaylistIndex]
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            showStatus("⏸️ Paused")
        } else {
            player.play()
            isPlaying = true
            showStatus("▶️ Playing")
        }
    }

    private func showStatus(_ message: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            statusMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.statusMessage = nil
            }
        }
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
            player?.delegate = self
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

    func nextSong() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentSongIndex = (currentSongIndex + 1) % currentPlaylist.songs.count
            currentSong = currentPlaylist.songs[currentSongIndex]
        }
        loadAndPlayCurrentSong()
    }

    func previousSong() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentSongIndex = (currentSongIndex - 1 + currentPlaylist.songs.count) % currentPlaylist.songs.count
            currentSong = currentPlaylist.songs[currentSongIndex]
        }
        loadAndPlayCurrentSong()
    }

    func nextPlaylist() {
        selectedPlaylistIndex = (selectedPlaylistIndex + 1) % playlists.count
        currentSongIndex = 0
        currentSong = currentPlaylist.songs[currentSongIndex]
        loadAndPlayCurrentSong()
    }

    func previousPlaylist() {
        selectedPlaylistIndex = (selectedPlaylistIndex - 1 + playlists.count) % playlists.count
        currentSongIndex = 0
        currentSong = currentPlaylist.songs[currentSongIndex]
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

    func unlockSecretPlaylist() {
        if !playlists.contains(where: { $0.id == secretPlaylist.id }) {
            playlists.append(secretPlaylist)
            selectedPlaylistIndex = playlists.count - 1
            currentSongIndex = 0
            currentSong = secretPlaylist.songs[0]
            loadAndPlayCurrentSong()
            showStatus("🎉 Party Mode Activated!")
        }
    }

    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.beginRecognition()
                } else {
                    self.showStatus("🎤 Permission denied")
                }
            }
        }
    }

    private func findMatchingPlaylist(from words: [String]) -> Playlist? {
        for word in words {
            if let match = playlists.first(where: { $0.name.lowercased().contains(word.lowercased()) }) {
                return match
            }
        }
        return nil
    }

    private func findMatchingSong(from words: [String]) -> Song? {
        for word in words {
            if let match = currentPlaylist.songs.first(where: { $0.name.lowercased().contains(word.lowercased()) }) {
                return match
            }
        }
        return nil
    }

    private func cancelTitleListeningIfInactive() {
        titleListeningTimer?.invalidate()
        titleListeningTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            if self.isListeningForTitle {
                self.isListeningForTitle = false
                self.collectedTitleWords = []
                self.showStatus("⚠️ Nothing recognized")
            }
        }
    }

    private func beginRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        recognitionTask?.cancel()
        recognitionTask = nil

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ AVAudioSession setup failed: \(error.localizedDescription)")
            return
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let spokenText = result.bestTranscription.segments.last?.substring.lowercased() ?? ""
                print("Heard: \(spokenText)")

                if self.isListeningForTitle {
                    self.cancelTitleListeningIfInactive()

                    self.collectedTitleWords.append(spokenText)

                    if let playlist = self.findMatchingPlaylist(from: self.collectedTitleWords) {
                        self.selectedPlaylistIndex = self.playlists.firstIndex(where: { $0.id == playlist.id }) ?? 0
                        self.currentSongIndex = 0
                        self.currentSong = playlist.songs[0]
                        self.loadAndPlayCurrentSong()
                        self.showStatus("📻 Playing \(playlist.name)")
                        self.isListeningForTitle = false
                        self.collectedTitleWords = []
                        return
                    }

                    if let song = self.findMatchingSong(from: self.collectedTitleWords) {
                        self.currentSong = song
                        self.loadAndPlayCurrentSong()
                        self.showStatus("▶️ \(song.name)")
                        self.isListeningForTitle = false
                        self.collectedTitleWords = []
                        return
                    }
                } else {
                    if spokenText.contains("stop") || spokenText.contains("pause") {
                        if self.isPlaying { self.togglePlayPause() }
                    } else if spokenText.contains("next") || spokenText.contains("skip") {
                        self.nextSong()
                    } else if spokenText.contains("back") || spokenText.contains("previous") {
                        self.previousSong()
                    } else if spokenText.contains("party") {
                        self.unlockSecretPlaylist()
                    } else if spokenText == "play" {
                        self.isListeningForTitle = true
                        self.collectedTitleWords = []
                        self.cancelTitleListeningIfInactive()
                        self.showStatus("🎤 Say the song or playlist name...")
                    } else if spokenText.contains("continue") || spokenText.contains("start") || spokenText.contains("resume") {
                        if !self.isPlaying { self.togglePlayPause() }
                    }
                }
            }

            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest?.endAudio()
                self.recognitionRequest = nil
                self.recognitionTask?.cancel()
                self.recognitionTask = nil

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !self.audioEngine.isRunning {
                        self.beginRecognition()
                    }
                }
            }
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("🎧 Listening...")
        } catch {
            print("❌ Audio Engine couldn't start: \(error.localizedDescription)")
        }
    }
}
