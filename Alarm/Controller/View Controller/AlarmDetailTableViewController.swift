//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Victor Monteiro on 6/8/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm?
    
    //MARK: VIew Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alarmDate = alarm?.fireDate else {return}
        alarmNameTextField.text = alarm?.name
        datePicker.date = alarmDate
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func saveButtonTappe(_ sender: UIBarButtonItem) {
        let date = datePicker.date
        guard let alarmName = alarmNameTextField.text, !alarmName.isEmpty else { return }
        
        if let alarm = alarm {
            AlarmController.shared.updateAlarm(alarm: alarm, name: alarmName, fireDate: date, enable: true)
            enableButton.isHidden = false
            print("Alarm updated")
        } else {
            AlarmController.shared.addAlarm(fireDate: date, name: alarmName, enable: true)
            enableButton.isHidden = true
            print("Alarm Created")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enabbleButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleIsEnabled(alarm: alarm)
        
        if alarm.enabled {
           
            updateUI()
            scheduleUserNotifications(for: alarm)
        } else {
           cancelUserNotifications(for: alarm)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    func updateUI() {
        if let alarm = alarm {
            enableButton.isHidden = false
            if alarm.enabled {
                enableButton.setTitle("Disable", for: .normal)
                enableButton.setTitleColor(.white, for: .normal )
                enableButton.backgroundColor = .red
            } else {
                enableButton.setTitle("Enable", for: .normal)
                enableButton.setTitleColor(.white, for: .normal)
                enableButton.backgroundColor = .systemBlue
            }
        } else {
            enableButton.isHidden = true
        }
        
    }
    
}

extension AlarmDetailTableViewController: AlarmScheduler {
    
}
