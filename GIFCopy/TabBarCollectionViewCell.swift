//
//  TabBarCollectionViewCell.swift
//  GIFCopy
//
//  Created by Vũ Việt Thắng on 01/06/2022.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var optionLabelView: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createCell(iconFileName: String, optionLabel: String){
        self.iconImageView.image = UIImage(named: iconFileName)
        self.optionLabelView.text = optionLabel
    }
    
}
