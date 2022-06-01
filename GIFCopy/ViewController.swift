//
//  ViewController.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 27/05/2022.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    @IBOutlet private weak var videoView: UIView!
    
    private var videoPHAssets = [PHAsset]()
    private var videoAVAsset: AVAsset?
    private var playerLooper: AVPlayerLooper?
    
    func setupLoopVideoView(){
        let randomVideoAssets = self.videoPHAssets.randomElement()
        randomVideoAssets?.getAVAsset(completionHandler: { asset in
            //setup player
            let playerItem = AVPlayerItem(asset: asset!)
            let randomVideoPlayer = AVQueuePlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: randomVideoPlayer)
            
            //setup player layer layout
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = .resize
            self.videoView.layer.addSublayer(playerLayer)
            
            //loop with queue player
            self.playerLooper = AVPlayerLooper(player: randomVideoPlayer, templateItem: playerItem)
            
            //play video
            randomVideoPlayer.play()
        })
    }
    
    private func loadAssetFromPhotos(){
        PHPhotoLibrary.requestAuthorization{ status in
            if status == .authorized {
                let videoAssets = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
                videoAssets.enumerateObjects{ (object, _, _) in
                    self.videoPHAssets.append(object)
                }
                DispatchQueue.main.async {
                    self.setupLoopVideoView()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadAssetFromPhotos()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCollectionViewCell", for: indexPath) as! TabBarCollectionViewCell
        cell.createCell(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - 12
        return CGSize(width: size, height: size)
    }
    
    
}
