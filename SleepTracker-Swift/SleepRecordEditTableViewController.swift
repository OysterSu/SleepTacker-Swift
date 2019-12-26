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
    
    private let sectionTitle = ["睡覺時間", "睡眠型態"]
    private let titleData = [["開始時間", "結束時間"], ["一般", "小睡"]]
    
    var sleepData: SleepData!
    
    var delegate: dismissControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SleepTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "SleepTime")
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SleepTime", for: indexPath) as! SleepTimeTableViewCell
            cell.textLabel?.text = NSLocalizedString(titleData[indexPath.section][indexPath.row], comment: "")
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            if indexPath.row == 0 {
                let startTime = dateFormatter.string(from: sleepData.startTime)
                cell.detailTextLabel?.text = startTime
            } else {
                let endTimeStr = dateFormatter.string(from: Date())
                cell.detailTextLabel?.text = endTimeStr
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sleepType", for: indexPath) as! SleepTypeTableViewCell
            cell.textLabel?.text = NSLocalizedString(titleData[indexPath.section][indexPath.row], comment: "")
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            }
            
            return cell
        }
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
        sleepData.endTime = Date()
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let result = Result{ try moc.save() }
        
        switch result {
        case .success( _):
            SleepStatus.shared.isSleep = false
            dismissController()
        case .failure(let error):
            let alert = AlertFactory.errorAlert(error)
            self.present(alert, animated: true, completion: nil)
        }
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
