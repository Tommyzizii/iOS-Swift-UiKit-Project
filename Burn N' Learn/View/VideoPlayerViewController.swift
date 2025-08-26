//
//  VideoPlayerViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {

    var videoFileName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Play the selected video when the view loads
        if let fileName = videoFileName {
            playVideo(fileName: fileName)
        }
    }

    // Function to play the video file from the project bundle
    func playVideo(fileName: String) {
        if let videoURL = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        } else {
            print("Video file not found")
        }
    }
}
