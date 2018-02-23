//
//  FeaturedItemsViewController.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem
import Nuke

class FeaturedItemsViewController: UIViewController, IndicatableView {
    
    //Outlets
    @IBOutlet weak var viewSelectCategory: UIView!
    @IBOutlet weak var labelSelectedCategory: UILabel!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    //Variables
    var selectedCategory: CategoryListModel?
    var categoryList = [CategoryListModel]()
    var productList = [ProductModel]()
    var selectedproduct: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Up UI Elements
        setUpUIElements()
        
        //get Data From Service
        self.getCategoriesListFromWebService()
    }
    
    func setUpUIElements() {
        
        //Set Default Label Titles
        self.labelSelectedCategory.text = selectedCategory != nil ? selectedCategory?.displayName : "Categories"
        
        //Navigation Bar Customization
        configureNavigationBarApperance()
        configureShoppingCartButton()
        
        // Register Nib
        self.collectionViewProducts.register(UINib.init(nibName: "FeaturedItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedItemCollectionViewCell")
        
        //Customize Select Category View
        self.viewSelectCategory.setDefaultBorder()
    }
    
    func getCategoriesListFromWebService() {
        
        //Display Loading Indicator
        self.showActivityIndicator()
        
        CategoryListAPIService.fetchCategoryList { (categoryResultModel, isError, errorStr) in
            
            //Hide Activity Indicator
            self.hideActivityIndicator()
            
            if !isError {
                
                //Response fetched Successfully
                if let categoryList = categoryResultModel?.contents {
                    self.categoryList = categoryList
                    
                    //Call First API to get Products for First Item
                    self.getProductListForproductId(productId: "150")
                }
                
            } else {
                
                print(errorStr!)
            }
        }
    }
    
    func getProductListForproductId(productId: String) {
        
        //Display Loading Indicator
        self.showActivityIndicator()
        
        ProductListAPIService.fetchProductList(productId) { (productResultModel, isError, errorStr) in
            
            //Hide Activity Indicator
            self.hideActivityIndicator()
            
            if !isError {
                
                //Response fetched Successfully
                if let productList = productResultModel?.records?.first?.records {
                    self.productList = productList
                    
                    //Reload Collection View
                    self.collectionViewProducts.reloadData()
                }
                
            } else {
                
                print(errorStr!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Modify Badge Values
        let badgeBarButton: BBBadgeBarButtonItem = self.navigationItem.rightBarButtonItem as! BBBadgeBarButtonItem
        badgeBarButton.badgeValue = String(productsInCartArray.count)
        
    }
    
    func configureNavigationBarApperance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.white
        
        navigationBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.darkGray, .font: UIFont.systemFont(ofSize: 20.0, weight: .medium)]
        
        let backImage = UIImage(named: "BackNavigation")?.withRenderingMode(.alwaysOriginal)
        navigationBarAppearance.backIndicatorImage = backImage
        navigationBarAppearance.backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
    }
    
    // MARK: - Actions
    // MARK: -
    @IBAction func buttonSelectCategoryTapped(_ sender: Any) {
        
        //Present popover to select Category
        self.presentPopOverFrom(sourceView: sender as! UIView, dataSourceArray: self.categoryList, popOverDelegate: self, popOverType: .SelectCategory, selectedItem: selectedCategory)
    }
    
    // MARK: - Segues
    // MARK:-
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ProductDetailsViewController"?:
            
            let productDetailCtrl: ProductDetailsViewController = segue.destination as! ProductDetailsViewController
            productDetailCtrl.selectedProduct = self.selectedproduct
        default:
            break
        }
    }
}

extension FeaturedItemsViewController: PopOverDelegate {
    
    func selectedPopOverItem(selectedItem: Any, popOverType: PopOverType) {
        
        switch popOverType {
        case .SelectCategory:
            
            let selectedCategory = selectedItem as! CategoryListModel
            self.selectedCategory = selectedCategory
            self.labelSelectedCategory.text = selectedCategory.displayName
            
            //Call Web Servid to get data for the selectd Category
            self.getProductListForproductId(productId: String(selectedCategory.id!))
            
        default:
            break
        }
    }
}

extension FeaturedItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell: FeaturedItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedItemCollectionViewCell", for: indexPath) as! FeaturedItemCollectionViewCell
        
        //Configure Cell
        
        //Set Image
        let productModel = self.productList[indexPath.row]
        let urlString = "http://static-data.surge.sh/assets/categories/\(productModel.productId!).png"
        Manager.shared.loadImage(with: URL.init(string: urlString)!, into: productCell.imageViewProductImage)
        
        //Set title
        productCell.labelProductTitle.text = productModel.productDisplayName
        
        //Set tag
        if let tag = productModel.productTag {
            
            //Display Tag
            productCell.viewTag.isHidden = false
            productCell.labelTag.text = tag
            
            //Change TagView Layout
            productCell.viewTag.layer.cornerRadius = 10.0
            productCell.viewTag.layer.masksToBounds = true
            productCell.viewTag.backgroundColor = getBackgroundColourForTag(tagStr: tag)
            
        } else {
            
            //Hide Tag
            productCell.viewTag.isHidden = true
        }
        
        //Set Offer
        if let productOfferBuy = productModel.productOfferBuy, let productOfferFree = productModel.productOfferFree {
            
            //Display Offer
            productCell.constraintOfferHeight.constant = 20
            productCell.labelOffer.text = "BUY \(String(productOfferBuy)) GET \(String(productOfferFree)) FREE"
        } else {
            
            //Hide Offer
            productCell.constraintOfferHeight.constant = 0
        }
        
        //Set price
        if Double(productModel.priceStrikeOff!)! > Double(productModel.skuFinalPrice!)! {
            
            //Display Strike off
            productCell.constraintStrikeOffpriceheight.constant = 35
            productCell.constraintFPheight.constant = 0
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(productModel.priceStrikeOff!)")
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            productCell.labelStrikeOffprice.attributedText = attributeString
            productCell.labelFinalPriceAfterStrike.text = "$\(productModel.skuFinalPrice!)"
            
        } else {
            
            //Display Current price
            productCell.constraintStrikeOffpriceheight.constant = 0
            productCell.constraintFPheight.constant = 35
            productCell.labelFinalPrice.text = "$\(productModel.skuFinalPrice!)"
        }
        
        //Set border
        productCell.setCollectionCellBorder()
        
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: collectionView.frame.size.width/2 - 10, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Navigate To product details page
        let selectedProduct = self.productList[indexPath.row]
        self.selectedproduct = selectedProduct
        self.performSegue(withIdentifier: "ProductDetailsViewController", sender: nil)
    }
}

