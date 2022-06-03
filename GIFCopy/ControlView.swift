//
//  ControlView.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 01/06/2022.
//

import Foundation
import UIKit

class ControlView: UIView{

    @IBOutlet private weak var rulerSliderScrollView: UIScrollView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var adjustOptionsCollectionView: UICollectionView!
    @IBOutlet private weak var indicatorView: UIView!
    
    var delegate: ControlViewDelegate?
    
    @IBAction func tapCancelButton(_ sender: UIButton){
        self.isHidden = true
        delegate?.controlView(self, didTapAtCancelButton: true)
    }
    
    func loadView() -> UIView{
        let bundleName = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundleName)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupRulerSliderView(){
        let indicesView = RulerIndicesView(frame: CGRect(x: 0, y: 0, width: 2420, height: rulerSliderScrollView.frame.height))
        indicesView.superviewHeight = Int(rulerSliderScrollView.frame.height)
        rulerSliderScrollView.contentSize = CGSize(width: 2420, height: 1)
        indicesView.backgroundColor = UIColor.black
        rulerSliderScrollView.layer.cornerRadius = 5
        rulerSliderScrollView.insertSubview(indicesView, at: 0)
    }
    
    private func setButtonEdgesRound(){
        cancelButton.layer.cornerRadius = cancelButton.bounds.width/2
        confirmButton.layer.cornerRadius = confirmButton.bounds.width/2
    }
    
    private func setupAdjustOptionsCollectionView(){
        adjustOptionsCollectionView.delegate = self
        adjustOptionsCollectionView.dataSource = self
        let width = adjustOptionsCollectionView.bounds.width
        let height = adjustOptionsCollectionView.bounds.height
        adjustOptionsCollectionView.contentInset = UIEdgeInsets(top: 0, left: (width-height)/2, bottom: 0, right: (width-height)/2)
        self.adjustOptionsCollectionView.register(UINib(nibName: "AdjustOptionsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AdjustOptionsCollectionViewCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRulerSliderView()
        setButtonEdgesRound()
        setupAdjustOptionsCollectionView()
    }
    
    func snapToCenter() {
        let centerPoint = self.convert(self.center, to: adjustOptionsCollectionView)
        guard let centerIndexPath = adjustOptionsCollectionView.indexPathForItem(at: centerPoint) else {return}
        adjustOptionsCollectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ControlView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }

}

extension ControlView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdjustOptionsCollectionViewCell", for: indexPath) as! AdjustOptionsCollectionViewCell
        cell.createCell(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        adjustOptionsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

protocol ControlViewDelegate{
    func controlView(_ view: UIView, didTapAtCancelButton bool: Bool)
}
