//
//  RecordMainViewController.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/24.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import UIKit

class RecordMainViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    private var isSleep: Bool = false {
        didSet {
            if isSleep {
                recordButton.setTitle("起床", for: .normal)
            } else {
                recordButton.setTitle("上床", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordButtonClick(_ sender: UIButton) {
        if isSleep {
            if let editViewController = self.storyboard?.instantiateViewController(identifier: "edit") {
                self.present(editViewController, animated: true, completion: nil)
            }
            
        }
        
        isSleep.toggle()
    }
    
}
