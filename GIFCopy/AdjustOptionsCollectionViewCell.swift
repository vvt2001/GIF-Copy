//
//  AdjustOptionsCollectionViewCell.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 03/06/2022.
//

import UIKit

class AdjustOptionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    let iconFileNameArray = ["brightness","contrast","saturation","clarity","shadow","highlight","sharpness"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createProgressBar()
        
    }
    
    func createProgressBar(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let center = self.center
        let circularPath = UIBezierPath(arcCenter: center, radius: self.bounds.width/2 - 3, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        
        self.layer.insertSublayer(shapeLayer, at: 0)
        
    }
    
    func createCell(index: Int){
        self.iconImageView.image = UIImage(named: iconFileNameArray[index])
//        self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.width/2
        self.layer.cornerRadius = self.bounds.width/2
    }
}
