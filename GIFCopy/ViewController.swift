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
    
    let optionLabels = ["Canvas","Trim","Speed","Add more","Effect","Filter","Sticker","Text","Frame","Background","Painting","Adjust","Reorder"]
    let iconFileNames = ["crop","cut","speed","add item","effect","filter","sticker","text","frame","background","painting","Adjust","reorder"]
    
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
            self.tabBarCollectionView.transform = CGAffineTransform(translationX: 0, y: (self.tabBarCollectionView.bounds.height)*1.5)
            self.controlView.transform = CGAffineTransform(translationX: 0, y: -(self.controlView.bounds.height)*1.5)
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
        
        NSLayoutConstraint.activate([controlView.leftAnchor.constraint(equalTo: videoView.leftAnchor),controlView.rightAnchor.constraint(equalTo: videoView.rightAnchor),controlView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: (self.controlView.bounds.height)*0.5)])
    }
    
    private func addBackgroundGradient(){
        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = view.frame
        bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        bottomGradient.locations = [0.7, 1.0]
        videoView.layer.insertSublayer(bottomGradient, at: 0)
        
        let topGradient = CAGradientLayer()
        topGradient.frame = view.frame
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0, 0.05]
        videoView.layer.insertSublayer(topGradient, at: 0)
    }
    
    private func showAlert(index: Int){
        let title = optionLabels[index]
        let message = "You have pressed " + title
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        return optionLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCollectionViewCell", for: indexPath) as! TabBarCollectionViewCell
        cell.createCell(index: indexPath.row, iconFileName: iconFileNames[indexPath.row], optionLabel: optionLabels[indexPath.row])
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
            showAlert(index: indexPath.row)
        }
    }
}

// MARK: - ControlViewDelegate
extension ViewController: ControlViewDelegate{
    func controlView(_ view: UIView) {
        animateShowTabBar()
    }
}
