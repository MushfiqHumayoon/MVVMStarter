//
//  ProductViewCell.swift
//  Product
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import UIKit

class ProductViewCell: UITableViewCell {

    @IBOutlet weak var labelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
