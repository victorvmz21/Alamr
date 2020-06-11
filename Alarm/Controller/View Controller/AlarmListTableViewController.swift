//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Victor Monteiro on 6/8/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.loadPersistenceData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        
        let alarm = AlarmController.shared.alarms[indexPath.row]
        
        cell?.delegate = self
        cell?.updateViews(with: alarm)
    
        // Configure the cell...

        return cell ?? UITableViewCell()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.removeAlarm(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVc" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let alarm = AlarmController.shared.alarms[indexPath.row]
            
            let destinationVC = segue.destination as? AlarmDetailTableViewController
                
            destinationVC?.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: AlarmCellDelegate, AlarmScheduler {

    
    func alarmSwitchToggled(for cell: SwitchTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarmToUpdate = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleIsEnabled(alarm: alarmToUpdate)
        
        if alarmToUpdate.enabled {
            scheduleUserNotifications(for: alarmToUpdate)
        } else {
            cancelUserNotifications(for: alarmToUpdate)
        }
        cell.updateViews(with: alarmToUpdate)
    }
    
    
}
