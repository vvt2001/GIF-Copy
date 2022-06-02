//
//  ControlView.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 01/06/2022.
//

import Foundation
import UIKit

class ControlView: UIView, UIScrollViewDelegate{

    @IBOutlet private weak var rulerSliderScrollView: UIScrollView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var adjustOptionsCollectionView: UICollectionView!
    
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
        rulerSliderScrollView.contentSize = CGSize(width: 2420, height: 1)
        indicesView.backgroundColor = UIColor.black
        rulerSliderScrollView.layer.cornerRadius = 5
        rulerSliderScrollView.insertSubview(indicesView, at: 0)
    }
    
    private func setButtonEdgesRound(){
        cancelButton.layer.cornerRadius = cancelButton.bounds.width/2
        confirmButton.layer.cornerRadius = confirmButton.bounds.width/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRulerSliderView()
        setButtonEdgesRound()
    }
}

protocol ControlViewDelegate{
    func controlView(_ view: UIView, didTapAtCancelButton bool: Bool)
}
