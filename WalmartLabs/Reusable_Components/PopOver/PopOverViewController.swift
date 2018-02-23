//
//  PopOverViewController.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit

protocol PopOverDelegate {
    func selectedPopOverItem(selectedItem: Any, popOverType: PopOverType)
}

class PopOverViewController: UIViewController {
    
    //Variables
    var dataSourceArray = [Any]()
    var delegate: PopOverDelegate?
    var popOverType: PopOverType!
    var selectedItem: Any?
    
    //Outlets
    @IBOutlet weak var tableViewPopOver: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Up View
        setUpView()
    }
    
    func setUpView() {
        
        //Set Dynamic Row Height for table view
        self.tableViewPopOver.estimatedRowHeight = 50
        self.tableViewPopOver.rowHeight = UITableViewAutomaticDimension
        
        //Register Nibs
        self.tableViewPopOver.register(UINib.init(nibName: "PopOverTableViewCell", bundle: nil), forCellReuseIdentifier: "PopOverTableViewCell")
        self.tableViewPopOver.register(UINib.init(nibName: "PopOverHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "PopOverHeaderTableViewCell")
    }
    
}

extension PopOverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contentCell: PopOverTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PopOverTableViewCell") as! PopOverTableViewCell
        
        //Configure Content Cell
        let popOverItem = self.dataSourceArray[indexPath.row]
        
        if popOverItem is String {
            
            //Country or City
            contentCell.labelTitle.text = popOverItem as? String
        } else if popOverItem is CategoryListModel {
            
            //Category List
            contentCell.labelTitle.text = (popOverItem as! CategoryListModel).displayName
            contentCell.labelTitle.isEnabled = (popOverItem as! CategoryListModel).active!
        }
        
        //Set Selected
        if let selectedItem = self.selectedItem {
            
            //Check Item Type
            if popOverItem is String {
                
                //Country or City
                contentCell.imageViewCheckmark.isHidden = (popOverItem as! String == selectedItem as! String) ? false: true
            } else if popOverItem is CategoryListModel {
                
                //Category List
                contentCell.imageViewCheckmark.isHidden = ((popOverItem as! CategoryListModel).id == (selectedItem as! CategoryListModel).id) ? false: true
            }
        } else {
            contentCell.imageViewCheckmark.isHidden = true
        }
        
        //Remove Selection style
        contentCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return contentCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell: PopOverHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PopOverHeaderTableViewCell") as! PopOverHeaderTableViewCell
        
        //Configure Header Cell
        switch popOverType {
        case .SelectCounty:
            headerCell.labelTitle.text = "Select Country"
        case .SelectCity:
            headerCell.labelTitle.text = "Select City"
        case .SelectCategory:
            headerCell.labelTitle.text = "Select Category"
        default:
            break
        }
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = self.dataSourceArray[indexPath.row]
        
        if selectedItem is CategoryListModel, !(selectedItem as! CategoryListModel).active! {
            
            //Do Nothing for Disabled Products
        } else {
            
            //Set Selected item
            self.selectedItem = selectedItem
            tableView.reloadData()
            
            //Close Popover for Catgory
            if popOverType == PopOverType.SelectCategory {
                self.dismiss(animated: true, completion: nil)
            }
            
            //Notify Delegate
            self.delegate?.selectedPopOverItem(selectedItem: selectedItem, popOverType: self.popOverType)
        }
    }
}
