//
//  RecordMainViewController.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/24.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import UIKit

class RecordMainViewController: UIViewController, dismissControllerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    
    private var isSleep: Bool! {
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
        
        isSleep = SleepStatus.shared.isSleep
    }
    
    @IBAction func recordButtonClick(_ sender: UIButton) {
        if !isSleep {
            let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let sleepManager = SleepDataManager(moc: moc)
            sleepManager.insert(entityName: "SleepData", attribute: ["startTime" : Date()]) { (result) in
                if case Result.failure(let error) = result {
                    let alert = AlertFactory.errorAlert(error)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.isSleep.toggle()
                }
            }
        } else {
            let editViewController = SleepRecordEditTableViewController(nibName: "SleepRecordEditTableViewController", bundle: nil)
            editViewController.delegate = self
            let naviController = UINavigationController(rootViewController: editViewController)

            self.present(naviController, animated: true, completion: nil)
        }
        
        isSleep.toggle()
    }
    
    func dismissHandler() {
        isSleep = SleepStatus.shared.isSleep
    }
    
}
