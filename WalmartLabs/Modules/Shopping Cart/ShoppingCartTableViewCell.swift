//
//  ShoppingCartTableViewCell.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 30/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProductImage: UIImageView!
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var labelproductPrice: UILabel!
    @IBOutlet weak var labelProductQuantity: UILabel!
    @IBOutlet weak var buttonRemoveFromCartTapped: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
