//
//  FeaturedItemCollectionViewCell.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit

class FeaturedItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelFinalPrice: UILabel!
    @IBOutlet weak var labelStrikeOffprice: UILabel!
    @IBOutlet weak var labelFinalPriceAfterStrike: UILabel!
    @IBOutlet weak var imageViewProductImage: UIImageView!
    @IBOutlet weak var labelOffer: UILabel!
    @IBOutlet weak var constraintOfferHeight: NSLayoutConstraint!
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var constraintFPheight: NSLayoutConstraint!
    @IBOutlet weak var constraintStrikeOffpriceheight: NSLayoutConstraint!
    @IBOutlet weak var viewTag: UIView!
    @IBOutlet weak var labelTag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
