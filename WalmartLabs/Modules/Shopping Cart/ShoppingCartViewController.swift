//
//  ShoppingCartViewController.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 30/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit
import Nuke

class ShoppingCartViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableViewMyCart: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up View
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() {
        
        //Set Dynamic Row Height for table view
        self.tableViewMyCart.estimatedRowHeight = 50
        self.tableViewMyCart.rowHeight = UITableViewAutomaticDimension
        
        //Register Nibs
        self.tableViewMyCart.register(UINib.init(nibName: "ShoppingCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartTableViewCell")
        
    }
    
    // MARK: - Actions
    // MARK: -
    @IBAction func buttonProceedToCheckoutTapped(_ sender: Any) {
        
        print("Implement Checkout Here")
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        
        //Dismiss Controller
        self.dismiss(animated: true) {
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInCartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contentCell: ShoppingCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell") as! ShoppingCartTableViewCell
        
        //Configure Content Cell
        let cartItem = productsInCartArray[indexPath.row]
        if let productModel = cartItem.product, let productQuantity = cartItem.quantity {
            
            //Set Image
            let urlString = "http://static-data.surge.sh/assets/categories/\(productModel.productId!).png"
            Manager.shared.loadImage(with: URL.init(string: urlString)!, into: contentCell.imageViewProductImage)
            
            //Set Title
            contentCell.labelProductTitle.text = productModel.productDisplayName
            
            //Set price
            contentCell.labelproductPrice.text = "$\(productModel.skuFinalPrice!)"
            
            //Set Quantity
            contentCell.labelProductQuantity.text = "Quantity:- \(String(productQuantity)) Items"
        }
        
        //Set Remove product button
        contentCell.buttonRemoveFromCartTapped.tag = indexPath.row
        contentCell.buttonRemoveFromCartTapped.addTarget(self, action: #selector(buttonRemoveFromCartTapped(sender:)), for: .touchUpInside)
        
        //Remove Selection style
        contentCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return contentCell
    }
    
    @objc func buttonRemoveFromCartTapped(sender: UIButton) {
        
        //Remove From Cart
        productsInCartArray.remove(at: sender.tag)
      
        //Reload Table
        self.tableViewMyCart.reloadData()
    }
}
