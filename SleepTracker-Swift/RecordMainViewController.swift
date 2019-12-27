//
//  RecordMainViewController.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/24.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import UIKit

class RecordMainViewController: UIViewController, dismissControllerDelegate {
    
    private var sleepManager: SleepDataManager!
    
    private var sleepData: SleepData!

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
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        sleepManager = SleepDataManager(moc: moc)
        
        decideSleepStatus()
    }
    
    private func decideSleepStatus() {
        let sortSescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        sleepManager.fetch(entityName: "SleepData", predicate: nil, sortDescriptors: [sortSescriptor], limit: 1) { (result) in
            switch result {
            case .success(let value):
                if value.count == 1 {
                    self.sleepData = value.first
                    if self.sleepData.endTime == nil {
                        SleepStatus.shared.isSleep = true
                    } else {
                        SleepStatus.shared.isSleep = false
                    }
                    
                    self.isSleep = SleepStatus.shared.isSleep
                }
            case .failure(let error):
                let alert = AlertFactory.errorAlert(error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func recordButtonClick(_ sender: UIButton) {
        if !isSleep {
            sleepManager.insert(entityName: "SleepData", attribute: ["startTime" : Date()]) { (result) in
                switch result {
                case .success(let value):
                    self.sleepData = value
                case .failure(let error):
                    let alert = AlertFactory.errorAlert(error)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.isSleep.toggle()
                }
            }
        } else {
            let editViewController = SleepRecordEditTableViewController(nibName: "SleepRecordEditTableViewController", bundle: nil)
            editViewController.sleepData = sleepData
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
