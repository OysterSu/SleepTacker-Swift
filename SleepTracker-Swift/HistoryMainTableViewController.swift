//
//  HistoryMainTableViewController.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪1 on 2019/12/25.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import UIKit

class HistoryMainTableViewController: UITableViewController {
    
    var sleepData: [SleepData] = []
    
    var sleepManager: SleepDataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        sleepManager = SleepDataManager(moc: moc)
        
        fetchData()
    }
    
    func fetchData() {
        let sortSescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        sleepManager.fetch(entityName: "SleepData", predicate: nil, sortDescriptors: [sortSescriptor]) { (result) in
            switch result {
            case .success(let data):
                self.sleepData = data
            case .failure(let error):
                let alert = AlertFactory.errorAlert(error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = .medium
        startDateFormatter.timeStyle = .medium
        let startTime = startDateFormatter.string(from: sleepData[indexPath.row].startTime)
        
        let endTimeDateFormatter = DateFormatter()
        endTimeDateFormatter.timeStyle = .medium
        var endTimeStr: String = ""
        if let endTime = sleepData[indexPath.row].endTime {
            endTimeStr = endTimeDateFormatter.string(from: endTime)
        }
        
        cell.textLabel?.text = startTime + " ~ " + endTimeStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            sleepManager.delete(object: sleepData[indexPath.row], callback: { (result) in
                switch result {
                case .success( _):
                    let alert = AlertFactory.successAlert(title: "刪除資料成功")
                    self.present(alert, animated: true, completion: nil)
                    
                    self.sleepData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    let alert = AlertFactory.errorAlert(error)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
            
        }
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
