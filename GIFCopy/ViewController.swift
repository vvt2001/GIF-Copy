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
    
    private var controlView = ControlView.loadView() 
    
    func animateShowTabBar(){
        tabBarCollectionView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.controlView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    func animateShowControlView(){
        controlView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarCollectionView.transform = CGAffineTransform(translationX: 0, y: (self.tabBarCollectionView.bounds.height))
            self.controlView.transform = CGAffineTransform(translationX: 0, y: -(self.controlView.bounds.height))
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
        
        NSLayoutConstraint.activate([controlView.leftAnchor.constraint(equalTo: videoView.leftAnchor),controlView.rightAnchor.constraint(equalTo: videoView.rightAnchor),controlView.topAnchor.constraint(equalTo: videoView.bottomAnchor)])
    }
    
    private func addBackgroundGradient(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: videoView.bounds.width, height: videoView.bounds.height))
        
        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = view.frame
        bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        bottomGradient.locations = [0.6, 1.0]
        view.layer.insertSublayer(bottomGradient, at: 0)
        
        let topGradient = CAGradientLayer()
        topGradient.frame = view.frame
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0, 0.05]
        view.layer.insertSublayer(topGradient, at: 0)
        
        videoView.insertSubview(view, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadAssetFromPhotos()
        setupControlView()
        addBackgroundGradient()
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
        return CGSize(width: size+8, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 11{
            animateShowControlView()
        }
        else{
            var title = String()
            var message = String()
            
            switch indexPath.row{
            case 0:
                title = "Canvas"
                message = "You have pressed Canvas"
            case 1:
                title = "Trim"
                message = "You have pressed Trim"
            case 2:
                title = "Speed"
                message = "You have pressed Speed"
            case 3:
                title = "Add more"
                message = "You have pressed Add more"
            case 4:
                title = "Effect"
                message = "You have pressed Effect"
            case 5:
                title = "Filter"
                message = "You have pressed Filter"
            case 6:
                title = "Sticker"
                message = "You have pressed Sticker"
            case 7:
                title = "Text"
                message = "You have pressed Text"
            case 8:
                title = "Frame"
                message = "You have pressed Frame"
            case 9:
                title = "Background"
                message = "You have pressed Background"
            case 10:
                title = "Painting"
                message = "You have pressed Painting"
            case 12:
                title = "Reorder"
                message = "You have pressed Reorder"
            default:
                break
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - ControlViewDelegate
extension ViewController: ControlViewDelegate{
    func controlView(_ view: UIView) {
        animateShowTabBar()
    }
}
