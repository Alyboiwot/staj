//
//  updatecell.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 21.08.2025.
//

import UIKit

class updatecell: UITableViewCell {
    @IBOutlet weak var productview: UIImageView!
    @IBOutlet weak var productlabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    let admincell = ProductViewModel()
    var product : Product?
  
    var onDelete : ((Product) -> Void)?
    var onUpdate : ((Product) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func updatebuttonclicked(_ sender: Any) {
      if let product = product{
            onUpdate?(product)
        }
        
    }
    @IBAction func deletebuttonclicked(_ sender: Any) {
        if let product = product{
            onDelete?(product)
        }
        
        
    }
}
