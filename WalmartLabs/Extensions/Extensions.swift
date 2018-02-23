//
//  Extensions.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIView {
    
    func setDefaultBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    func setCollectionCellBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    func presentPopOverFrom(sourceView: UIView, dataSourceArray: [Any], popOverDelegate: PopOverDelegate, popOverType: PopOverType, selectedItem: Any?) {
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popOverController: PopOverViewController = mainStoryboard.instantiateViewController(withIdentifier: "PopOverViewController") as! PopOverViewController
        popOverController.modalPresentationStyle = .popover
        popOverController.dataSourceArray = dataSourceArray
        popOverController.delegate = popOverDelegate
        popOverController.popOverType = popOverType
        popOverController.selectedItem = selectedItem
        
        //Set Content Size for popover
        let popOverHeight = dataSourceArray.count * 45 > 250 ? 250 : dataSourceArray.count * 45
        popOverController.preferredContentSize = CGSize.init(width: Int(self.view.frame.size.width - 20), height: popOverHeight)
        
        //Create PopOver presentation
        let popover = popOverController.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sourceView
        popover.sourceRect = sourceView.bounds
        
        //Present PopOver
        self.present(popOverController, animated: true) {
        }
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIViewController {
    
    func presentAlertWith(alertTitle: String, alertMessage: String) {
        
        let alertCtrl = UIAlertController.init(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        //Add Action
        alertCtrl.addAction(UIAlertAction.init(title: "Ok", style: .destructive, handler: { (alertAction) in
        }))
        
        //present Alert
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func configureShoppingCartButton() {
        
        let buttonShoppingCart = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25.0, height: 25.0))
        buttonShoppingCart.setImage(UIImage.init(named: "shopping-cart"), for: .normal)
        buttonShoppingCart.addTarget(self, action: #selector(goToMyShoppingCart), for: .touchUpInside)
        
        // Create and add our custom BBBadgeBarButtonItem
        let badgeBarButton: BBBadgeBarButtonItem = BBBadgeBarButtonItem.init(customUIButton: buttonShoppingCart)
        badgeBarButton.badgeValue = String(productsInCartArray.count)
        badgeBarButton.badgeBGColor = UIColor.init(red: 237.0/255.0, green: 97.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        badgeBarButton.badgeOriginX += 5
        
        // Add it as the leftBarButtonItem of the navigation bar
        self.navigationItem.rightBarButtonItem = badgeBarButton;
    }
    
    @objc func goToMyShoppingCart() {
        
        let shopingCartCtrl: ShoppingCartViewController = mainListBoard.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
        self.present(UINavigationController.init(rootViewController: shopingCartCtrl), animated: true, completion: nil)
    }
}


