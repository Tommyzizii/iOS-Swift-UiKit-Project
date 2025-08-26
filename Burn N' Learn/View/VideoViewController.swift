//
//  VideoViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit
import AVKit

class VideoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel = VideoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Bind ViewModel to update the collection view
        bindViewModel()
        viewModel.loadVideos() // Load the video data
    }

    // Bind ViewModel to collection view
    private func bindViewModel() {
        viewModel.videosChanged = { [weak self] videos in
            self?.collectionView.reloadData()
        }
    }

    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredVideos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = viewModel.filteredVideos[indexPath.item]
        
        cell.configure(with: video)
        
        // Handle play button tap
        cell.playButtonAction = { [weak self] in
            self?.viewModel.playVideo(fileName: video.fileName, from: self!)
        }
        
        return cell
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterVideos(with: searchText)
    }
}
