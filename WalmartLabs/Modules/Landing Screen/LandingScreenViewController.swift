//
//  LandingScreenViewController.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import UIKit

class LandingScreenViewController: UIViewController {

    //Outlets
    @IBOutlet weak var viewSelectCountry: UIView!
    @IBOutlet weak var labelSelectCountry: UILabel!
    @IBOutlet weak var viewSelectCity: UIView!
    @IBOutlet weak var labelSelectCity: UILabel!
    
    //Variables
    var selectedCountry = ""
    var selectedCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Up UI Elements
        setUpUIElements()
    }

    func setUpUIElements() {
        
        //Set Default Label Titles
        self.labelSelectCountry.text = selectedCountry.count > 0 ? selectedCountry: "Select Country"
        self.labelSelectCity.text = selectedCity.count > 0 ? selectedCity: "Select City"
        
        //Set Border to View
        self.viewSelectCity.setDefaultBorder()
        self.viewSelectCountry.setDefaultBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    // MARK: -
    @IBAction func buttonApplyTapped(_ sender: Any) {
        
        if selectedCity == "" && selectedCountry == "" {
            self.presentAlertWith(alertTitle: "Alert", alertMessage: "Please select valid Country and City")
        } else if selectedCity == "" {
            self.presentAlertWith(alertTitle: "Alert", alertMessage: "Please select valid City")
        } else if selectedCountry == "" {
            self.presentAlertWith(alertTitle: "Alert", alertMessage: "Please select valid Country")
        } else {
            
            //Navigate To Featured Items
            self.performSegue(withIdentifier: "FeaturedItemsViewController", sender: nil)
        }
    }
    
    @IBAction func buttonSelectCountryTapped(_ sender: Any) {
        
        //Present popover to select country
        self.presentPopOverFrom(sourceView: sender as! UIView, dataSourceArray: countryListArray, popOverDelegate: self, popOverType: .SelectCounty, selectedItem: self.labelSelectCountry.text)
    }
    
    @IBAction func buttonSelectCityTapped(_ sender: Any) {
        
        //Present popover to select City
        self.presentPopOverFrom(sourceView: sender as! UIView, dataSourceArray: cityListArray, popOverDelegate: self, popOverType: .SelectCity, selectedItem: self.labelSelectCountry.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass Data to next Controller here
    }
}

extension LandingScreenViewController: PopOverDelegate {
    
    func selectedPopOverItem(selectedItem: Any, popOverType: PopOverType) {
        
        switch popOverType {
        case .SelectCounty:
            
            let selectedCountry = selectedItem as! String
            self.selectedCountry = selectedCountry
            self.labelSelectCountry.text = selectedCountry
        case .SelectCity:
            
            let selectedCity = selectedItem as! String
            self.selectedCity = selectedCity
            self.labelSelectCity.text = selectedCity
        default:
            break
        }
    }
}
