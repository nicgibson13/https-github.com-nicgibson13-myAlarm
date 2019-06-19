//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        datePick.date = alarm.fireDate
        detailTextField.text = alarm.name
        alarmIsOn = alarm.isEnabled
    }
    
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var detailViewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = detailTextField.text else {return}
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: datePick.date, name: alarmName, isEnabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: datePick.date, name: alarmName, isEnabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func enableButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleEnabled(for: alarm)
            alarmIsOn = alarm.isEnabled
        }else{
            alarmIsOn = !alarmIsOn
        }
    }
    
    
}
