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
    @IBOutlet weak var videoView: UIView!
    
    private var videoPHAssets = [PHAsset]()
    private var videoAVAsset: AVAsset?
    private var playerLooper: AVPlayerLooper?
    
    private func loadAssetFromPhotos(handleClosure: @escaping (() -> Void)){
        PHPhotoLibrary.requestAuthorization{ status in
            if status == .authorized {
                let videoAssets = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
                videoAssets.enumerateObjects{ (object, _, _) in
                    self.videoPHAssets.append(object)
                }
                DispatchQueue.main.async {
                    handleClosure()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let playLoopVideo = {
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
        
        loadAssetFromPhotos(handleClosure: playLoopVideo)
    }
}

