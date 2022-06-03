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
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var tabBarCollectionView: UICollectionView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var videoPHAssets = [PHAsset]()
    private var videoAVAsset: AVAsset?
    private var playerLooper: AVPlayerLooper?
    
    private var controlView = ControlView().loadView() as! ControlView
    
    func animateShow(view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: -(view.bounds.height))
        }, completion: nil)
    }
    
    func animateHide(view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    

    
    func setupLoopVideoView(){
        let randomVideoAssets = self.videoPHAssets.randomElement()
        randomVideoAssets?.getAVAsset(completionHandler: { asset in
            //setup player
            let playerItem = AVPlayerItem(asset: asset!)
            let randomVideoPlayer = AVQueuePlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: randomVideoPlayer)
            
            //setup player layer layout
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = .resizeAspect
            self.videoView.layer.insertSublayer(playerLayer, at: 0)
            
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
                    self.setupCollectionViews()

                }
            }
        }
    }
    

    private func setupCollectionViews(){
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        self.tabBarCollectionView.register(UINib(nibName: "TabBarCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TabBarCollectionViewCell")
    }
    
    private func setupControlView(){
        controlView.delegate = self
        videoView.insertSubview(controlView, at: 0)
        controlView.isHidden = true
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([controlView.leftAnchor.constraint(equalTo: videoView.leftAnchor),controlView.rightAnchor.constraint(equalTo: videoView.rightAnchor),controlView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadAssetFromPhotos()
        setupControlView()

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
        let size = collectionView.bounds.height
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 11{
            controlView.isHidden = false
            collectionView.isHidden = true
        }
    }
}

// MARK: - ControlViewDelegate
extension ViewController: ControlViewDelegate{
    func controlView(_ view: UIView, didTapAtCancelButton bool: Bool) {
        tabBarCollectionView.isHidden = false
    }
}
