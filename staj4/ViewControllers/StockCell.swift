//
//  StockCell.swift
//  staj4
//
//  Created by Ali Ünal UZUNÇAYIR on 7.08.2025.
//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var stocknamebox: UILabel!
    @IBOutlet weak var dividendbox: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName:imageName)
        let tintColor = isFavorite ? UIColor.systemYellow : UIColor.systemGray
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = tintColor
    }

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
