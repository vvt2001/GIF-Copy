//
//  ControlView.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 01/06/2022.
//

import UIKit

class RulerIndicesView: UIView{
    
    var superviewHeight: Int!
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        var rectangle: CGRect
        for index in 0...240{
            if index % 10 == 0{
                rectangle = CGRect(x: 10+10*index, y: (superviewHeight - 20) / 2, width: 2, height: 20)
            }
            else{
                rectangle = CGRect(x: 10+10*index, y: (superviewHeight - 12) / 2, width: 1, height: 12)
            }
            context.setFillColor(UIColor.white.cgColor)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
            context.fill(rectangle)
        }
    }
}
