//
//  OnboardingViewModel.swift
//  Video_test
//
//  Created by Никита on 7.06.25.
//

import SwiftUI
import AVKit
import Combine

class OnboardingViewModel: ObservableObject {
    private(set) var items: [OnboardingItemModel] = []
    
    @Published var currentPage: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isMuted: Bool = false
    
    private(set) var players: [Int: AVPlayer] = [:]
    private var playbackTimes: [Int: CMTime] = [:]
    private var playersIsMuted: [Int: Bool] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupItems()
        setupBindings()
    }
    
    private func setupItems() {
        items = [
            OnboardingItemModel(id: 0, title: "Welcome to our app", videoName: "Testdrive_01", videoExtension: "mp4"),
            OnboardingItemModel(id: 1, title: "Discover amazing features", videoName: "Testdrive_02", videoExtension: "mp4"),
            OnboardingItemModel(id: 2, title: "Get started today", videoName: "Testdrive_03", videoExtension: "mp4")
        ]
    }
    
    private func setupBindings() {
        cancellables.removeAll()
        $currentPage
            .sink { [weak self] newPage in
                self?.setupPlayer(for: newPage)
                self?.pauseAllExcept(page: newPage)
            }
            .store(in: &cancellables)
        
        $isPlaying
            .sink { [weak self] value in
                if value {
                    self?.play(page: self?.currentPage ?? 0)
                } else {
                    self?.pause(page: self?.currentPage ?? 0)
                }
            }
            .store(in: &cancellables)
        
        $isMuted
            .sink { [weak self] value in
                self?.players[self?.currentPage ?? 0]?.isMuted = value
                self?.playersIsMuted[self?.currentPage ?? 0] = value
            }
            .store(in: &cancellables)
        

    }
    
    private func setupPlayer(for page: Int) {
        if players[page] != nil {
            return
        }
        
        let item = items[page]
        let player = AVPlayer(url: item.videoURL)
        player.actionAtItemEnd = .none
        player.isMuted = self.playersIsMuted[page] ?? false
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                             object: player.currentItem,
                                             queue: .main) { [weak player] _ in
                player?.seek(to: .zero)
                player?.play()
        }
        players[page] = player
    }
    
    private func play(page: Int) {
        guard let player = players[page] else { return }
        if let time = playbackTimes[page] {
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        }
        player.play()
    }
    
    private func pause(page: Int) {
        guard let player = players[page] else { return }
        player.pause()
        playbackTimes[page] = player.currentTime()
    }
    
    private func pauseAllExcept(page: Int) {
        players.forEach { (key, player) in
            if key != page {
                players[key]?.pause()
                playbackTimes[key] = player.currentTime()
            }
        }
    }
    
    func nextPage() {
        guard currentPage < items.count - 1 else { return }
        currentPage += 1
    }
    
    func previousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }
    
    func reset(page: Int) {
        players.forEach { (key, player) in
            if key != page {
                players[key]?.pause()
                if let item = players[key]?.currentItem {
                    NotificationCenter.default.removeObserver(self,
                                                              name: .AVPlayerItemDidPlayToEndTime,
                                                              object: item)
                }
                players[key]?.replaceCurrentItem(with: nil)
                players.removeValue(forKey: key)
            }
        }
    }
    
    private func resetAll() {
        NotificationCenter.default.removeObserver(self)
        
        players.forEach {
            $0.value.pause()
            $0.value.replaceCurrentItem(with: nil)
        }
        playbackTimes.removeAll()
        players.removeAll()
        cancellables.removeAll()
    }

    deinit {
        resetAll()
    }
}
