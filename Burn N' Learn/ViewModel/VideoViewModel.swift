//
//  VideoViewModel.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 30/9/2567 BE.
//

import Foundation
import AVKit

class VideoViewModel {
    
    var videos: [VideoInfo] = []
    var filteredVideos: [VideoInfo] = [] {
        didSet {
            videosChanged?(filteredVideos)
        }
    }
    
    // Closure to bind video data to the view controller
    var videosChanged: (([VideoInfo]) -> Void)?
    
    init() {
        loadVideos()
    }
    
    // Load sample video data
    func loadVideos() {
        videos = [
                    VideoInfo(title: "Water", fileName: "water 1"),
                    VideoInfo(title: "Food affects your brain", fileName: "food affects your brain"),
                    VideoInfo(title: "When is water safe to drink", fileName: "When is water safe to drink"),
                    VideoInfo(title: "Sugar affects the brain", fileName: "sugar affects the brain"),
                    VideoInfo(title: "Spot a fad diet", fileName: "spot a fad diet"),
                    VideoInfo(title: "Playing sports of benefits", fileName: "playing sports of benefits"),
                    VideoInfo(title: "Our muscles get tired", fileName: "our muscles get tired"),
                    VideoInfo(title: "Carbohydrates", fileName: "carbohydrates"),
                    VideoInfo(title: "Sugar Hiding in plain sight", fileName: "Sugar Hiding in plain sight"),
                    VideoInfo(title: "Motivation", fileName: "Motivation"),
                    VideoInfo(title: "What makes muscles grow", fileName: "What makes muscles grow"),
                    VideoInfo(title: "What is fat", fileName: "What is fat"),
                    VideoInfo(title: "What is a calorie", fileName: "What is a calorie"),
                    VideoInfo(title: "How the food you eat affects your gut", fileName: "How the food you eat affects your gut"),
                    VideoInfo(title: "How do vitamins work", fileName: "How do vitamins work"),
                    VideoInfo(title: "What’s the best way to treat cold", fileName: "What’s the best way to treat cold"),
                    VideoInfo(title: "The benefits of a good night's sleep", fileName: "The benefits of a good night's sleep"),
                    VideoInfo(title: "How stress affects your body", fileName: "How stress affects your body"),
                    VideoInfo(title: "How does your body know you're full", fileName: "How does your body know you're full")
                ]
        filteredVideos = videos
    }
    
    // Handle search and filtering logic
    func filterVideos(with searchText: String) {
        if searchText.isEmpty {
            filteredVideos = videos
        } else {
            filteredVideos = videos.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Play the selected video
    func playVideo(fileName: String, from viewController: UIViewController) {
        if let videoURL = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            viewController.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        } else {
            print("Video file not found")
        }
    }
}

