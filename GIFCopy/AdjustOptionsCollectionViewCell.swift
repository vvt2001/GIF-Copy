//
//  AdjustOptionsCollectionViewCell.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 03/06/2022.
//

import UIKit

class AdjustOptionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    var scrollValue: Double! = 0
    var shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createProgressBar()
    }
    
    func changeCellToImage(){
        iconImageView.isHidden = false
        valueLabel.isHidden = true
    }
    
    func changeCellToValue(){
        valueLabel.text = "\(Int(scrollValue*100))"
        iconImageView.isHidden = true
        valueLabel.isHidden = false
    }
    
    func changeStrokeWithAnimation(value: Double){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "")
        scrollValue = value
        self.valueLabel.text = "\(Int(value*100))"
    }
    
    func createProgressBar(){
        shapeLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let center = self.center
        var circularPath: UIBezierPath
        circularPath = UIBezierPath(arcCenter: center, radius: self.bounds.width/2 - 5, startAngle: -CGFloat.pi/2, endAngle: 3/2*CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeEnd = scrollValue
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func createCell(index: Int, iconFileName: String){
        self.iconImageView.image = UIImage(named: iconFileName)
        self.layer.cornerRadius = self.bounds.width/2
    }
}
