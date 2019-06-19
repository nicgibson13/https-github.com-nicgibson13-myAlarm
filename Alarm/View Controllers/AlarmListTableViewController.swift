//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toAlarmEdit", for: indexPath) as? SwitchTableViewCell else {return UITableViewCell()}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        // Configure the cell...
        cell.updateViews(alarm: alarm)
        delegate = self as SwitchTableViewCellDelegate
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmEdit" {
            guard let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? AlarmDetailTableViewController
                else {return}
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            destinationVC.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        cell.updateViews(alarm: alarm)
    }
    
    
}
