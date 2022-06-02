//
//  ControlView.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 01/06/2022.
//

import UIKit

class RulerIndicesView: UIView{
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        for index in 0...240{
            if index % 10 == 0{
                let rectangle = CGRect(x: 10+10*index, y: 8, width: 2, height: 16)
                context.setFillColor(UIColor.white.cgColor)
                context.addRect(rectangle)
                context.drawPath(using: .fill)
                context.fill(rectangle)
            }
            else{
                let rectangle = CGRect(x: 10+10*index, y: 11, width: 1, height: 10)
                context.setFillColor(UIColor.white.cgColor)
                context.addRect(rectangle)
                context.drawPath(using: .fill)
                context.fill(rectangle)
            }
        }
    }
}
