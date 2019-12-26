//
//  SleepRecordEditTableViewController.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/24.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import UIKit
import DatePickerCell

protocol dismissControllerDelegate {
    func dismissHandler()
}

class SleepRecordEditTableViewController: UITableViewController {
    
    let sectionTitle = ["睡覺時間", "睡眠型態"]
    let titleData = [["開始時間", "結束時間"], ["一般", "小睡"]]
    
    var delegate: dismissControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SleepTimeTableViewCell.self, forCellReuseIdentifier: "sleepTime")
        tableView.register(SleepTypeTableViewCell.self, forCellReuseIdentifier: "sleepType")
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        self.title = NSLocalizedString("編輯資料", comment: "")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "sleepTime", for: indexPath) as! SleepTimeTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "sleepType", for: indexPath) as! SleepTypeTableViewCell
        }
        
        cell.textLabel?.text = NSLocalizedString(titleData[indexPath.section][indexPath.row], comment: "")
        
        if indexPath.section == 1, indexPath.row == 0 {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            for i in 0...titleData[indexPath.section].count {
                let indexPath = IndexPath(item: i, section: indexPath.section)
                let cell = tableView.cellForRow(at: indexPath)!
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    break
                }
            }
            
            let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Action

    @objc func save() {
        SleepStatus.shared.isSleep = false
        
        dismissController()
    }
    
    @objc func cancel() {
        SleepStatus.shared.isSleep = true
        
        dismissController()
    }
    
    private func dismissController() {
        self.delegate?.dismissHandler()
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
