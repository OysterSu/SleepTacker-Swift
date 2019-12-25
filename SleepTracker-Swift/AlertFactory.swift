//
//  AlertFactory.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪1 on 2019/12/25.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import Foundation
import UIKit

class AlertFactory {
    
    class func successAlert(title: String) -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: ""), message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: NSLocalizedString("確定", comment: ""), style: .default, handler: nil)
        alert.addAction(confirm)
        
        return alert
    }
    
    class func errorAlert(_ error: Error) -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("錯誤", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: NSLocalizedString("確定", comment: ""), style: .default, handler: nil)
        alert.addAction(confirm)
        
        return alert
    }
}
