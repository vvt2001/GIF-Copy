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
    
    weak var delegate: ControlViewDelegate?
    var currentOptionIndexPath = IndexPath(row: 0, section: 0)
    
    @IBAction func tapCancelButton(_ sender: UIButton){
        delegate?.controlView(self, didTapAtCancelButton: true)
    }
    
    static func loadView() -> ControlView{
        let bundleName = Bundle(for: self)
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundleName)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! ControlView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupRulerSliderView(){
        let indicesView = RulerIndicesView(frame: CGRect(x: 0, y: 0, width: 1355, height: rulerSliderScrollView.frame.height))
        indicesView.superviewHeight = Int(rulerSliderScrollView.frame.height)
        rulerSliderScrollView.contentSize = CGSize(width: 1355, height: 1)
        indicesView.backgroundColor = UIColor.black
        rulerSliderScrollView.layer.cornerRadius = 5
        rulerSliderScrollView.insertSubview(indicesView, at: 0)
        rulerSliderScrollView.delegate = self
    }
    
    private func setButtonEdgesRound(){
        cancelButton.layer.cornerRadius = cancelButton.bounds.width/2
        confirmButton.layer.cornerRadius = confirmButton.bounds.width/2
    }
    
    private func setupAdjustOptionsCollectionView(){
        adjustOptionsCollectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        adjustOptionsCollectionView.delegate = self
        adjustOptionsCollectionView.dataSource = self
        let width = adjustOptionsCollectionView.bounds.width
        let height = adjustOptionsCollectionView.bounds.height
        adjustOptionsCollectionView.contentInset = UIEdgeInsets(top: 0, left: (width-height)/2, bottom: 0, right: (width-height)/2)
        self.adjustOptionsCollectionView.register(UINib(nibName: "AdjustOptionsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AdjustOptionsCollectionViewCell")
    }
    
    private func updateAdjustOptionCollectionView(selectedIndexPath: IndexPath){
        currentOptionIndexPath = selectedIndexPath
        for index in 0...6{
            if index != selectedIndexPath.row{
                if let remainCell = adjustOptionsCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? AdjustOptionsCollectionViewCell
                {
                    remainCell.changeCellToImage()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRulerSliderView()
        setButtonEdgesRound()
        setupAdjustOptionsCollectionView()
    }
    
    private func snapToCenter() {
        let centerPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let centerPointOfCollectionView = adjustOptionsCollectionView.convert(centerPoint, from: self)
        guard let centerIndexPath = adjustOptionsCollectionView.indexPathForItem(at: centerPointOfCollectionView) else {return}
        adjustOptionsCollectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        updateAdjustOptionCollectionView(selectedIndexPath: centerIndexPath)
    }
}

extension ControlView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == adjustOptionsCollectionView{
            snapToCenter()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == adjustOptionsCollectionView{
            if !decelerate {
                snapToCenter()
            }
        }
        else{
            if let cell = adjustOptionsCollectionView.cellForItem(at: currentOptionIndexPath) as? AdjustOptionsCollectionViewCell{
                cell.changeCellToImage()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == rulerSliderScrollView{
            if let cell = adjustOptionsCollectionView.cellForItem(at: currentOptionIndexPath) as? AdjustOptionsCollectionViewCell{
                cell.changeCellToValue()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rulerSliderScrollView{
            let offsetValue = rulerSliderScrollView.contentOffset.x
            if let cell = self.adjustOptionsCollectionView.cellForItem(at: currentOptionIndexPath) as? AdjustOptionsCollectionViewCell {
                cell.changeStrokeWithAnimation(value: offsetValue/1000)
            }
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
        updateAdjustOptionCollectionView(selectedIndexPath: indexPath)
    }
}

protocol ControlViewDelegate: AnyObject{
    func controlView(_ view: UIView, didTapAtCancelButton bool: Bool)
}
