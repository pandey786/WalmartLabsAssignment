//
//  IndicatableViewExtension.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension IndicatableView where Self: UIViewController {
    
    func showActivityIndicator() {
        SVProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
    }
}
