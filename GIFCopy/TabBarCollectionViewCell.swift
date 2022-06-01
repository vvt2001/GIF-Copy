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
    
    let optionLabelArray = ["Canvas","Trim","Speed","Add more","Effect","Filter","Sticker","Text","Frame","Background","Painting","Adjust","Reorder"]
    let iconFileNameArray = ["crop","cut","speed","add item","effect","filter","sticker","text","frame","background","painting","Adjust","reorder"]
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createCell(index: Int){
        self.iconImageView.image = UIImage(named: iconFileNameArray[index])
        self.optionLabelView.text = optionLabelArray[index]
    }

}
