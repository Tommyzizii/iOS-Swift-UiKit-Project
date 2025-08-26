//
//  VideoCell.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!
    
    var playButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        videoImageView.layer.cornerRadius = 10
        videoImageView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 2.0 // Set the border width
        self.layer.borderColor = UIColor.systemGray5.cgColor // Set the border color

        // Add shadow if needed
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false // Ensure shadow doesn't get clipped
    }
    
    func configure(with video: VideoInfo) {
        playButton.setTitle(video.title, for: .normal)
        
        // Set the image for the video
        let imageName = "\(video.fileName).jpg" // Assumes image file names match the video names
        if let image = UIImage(named: imageName) {
            videoImageView.image = image
        } else {
            videoImageView.image = nil
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playButtonAction?()
    }
    
}
