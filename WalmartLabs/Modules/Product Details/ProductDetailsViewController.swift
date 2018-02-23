//
//  ProductDetailsViewController.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 30/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem
import Nuke

class ProductDetailsViewController: UIViewController {
    
    //Variables
    var selectedProduct: ProductModel?
    var currentProductCount = 1
    
    //Outlets
    @IBOutlet weak var imageViewProductImage: UIImageView!
    @IBOutlet weak var labelproductTitle: UILabel!
    @IBOutlet weak var labelproductprice: UILabel!
    @IBOutlet weak var labelOffer: UILabel!
    @IBOutlet weak var labelCurrentStepperQuantity: UILabel!
    @IBOutlet weak var viewStepper: UIView!
    @IBOutlet weak var labelStrikeOffprice: UILabel!
    @IBOutlet weak var labelFinalPriceAfterStrike: UILabel!
    @IBOutlet weak var constraintFPheight: NSLayoutConstraint!
    @IBOutlet weak var constraintStrikeOffpriceheight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar Customization
        configureShoppingCartButton()
        
        //UI Setup
        configureStepperLabelView()
        
        //Set stepper Label
        self.labelCurrentStepperQuantity.text = String(currentProductCount)
        
        //set Data On View
        setDataOnView()
    }
    
    func setDataOnView() {
        
        if let productModel = self.selectedProduct {
            
            //Set Image
            let urlString = "http://static-data.surge.sh/assets/categories/\(productModel.productId!).png"
            Manager.shared.loadImage(with: URL.init(string: urlString)!, into: self.imageViewProductImage)
            
            //Set title
            self.labelproductTitle.text = productModel.productDisplayName
            
            //Set Offer Text
            self.labelOffer.text = "Add one more item to Avail 1 item FREE"
        
            //Set price
            if Double(productModel.priceStrikeOff!)! > Double(productModel.skuFinalPrice!)! {
                
                //Display Strike off
                self.constraintStrikeOffpriceheight.constant = 45
                self.constraintFPheight.constant = 0
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(productModel.priceStrikeOff!)")
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                self.labelStrikeOffprice.attributedText = attributeString
                self.labelFinalPriceAfterStrike.text = "$\(productModel.skuFinalPrice!)"
                
            } else {
                
                //Display Current price
                self.constraintStrikeOffpriceheight.constant = 0
                self.constraintFPheight.constant = 45
                self.labelproductprice.text = "$\(productModel.skuFinalPrice!)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureStepperLabelView() {
        viewStepper.layer.cornerRadius = 5.0
        viewStepper.layer.masksToBounds = true
    }

    // MARK: - Actions
    // MARK: -
    @IBAction func buttonAddToCartTapped(_ sender: Any) {
    
        //Add Product to Cart
        var cartProduct = CartProduct()
        cartProduct.product = self.selectedProduct
        cartProduct.quantity = currentProductCount
        productsInCartArray.append(cartProduct)
        
        //Update Badge
        let badgeBarButton: BBBadgeBarButtonItem = self.navigationItem.rightBarButtonItem as! BBBadgeBarButtonItem
        badgeBarButton.badgeValue = String(productsInCartArray.count)
        
        //Reset Counts
        currentProductCount = 1
        
        //Reset stepper Label
        self.labelCurrentStepperQuantity.text = String(currentProductCount)
    }
    
    @IBAction func buttonStepperMinusTapped(_ sender: Any) {
        
        if currentProductCount > 1 {
            currentProductCount -= 1
            
            //Set stepper Label
            self.labelCurrentStepperQuantity.text = String(currentProductCount)
        }
    }
    
    @IBAction func buttonStepperPlusTapped(_ sender: Any) {
        
        if currentProductCount < 5 {
            currentProductCount += 1
            
            //Set stepper Label
            self.labelCurrentStepperQuantity.text = String(currentProductCount)
        }
    }
}
