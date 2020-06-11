//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Victor Monteiro on 6/8/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit

protocol AlarmCellDelegate: AnyObject {
    func alarmSwitchToggled(for cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    //MARK: - IBOulets
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    //MARK: - Properties
    weak var delegate: AlarmCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews(with: alarm!)
        }
    }
    
    //MARK: - IBActions
    @IBAction func AlarmSwitchToggle(_ sender: UISwitch) {
        delegate?.alarmSwitchToggled(for: self)
    }
    
    //MARK: - Methods
    func updateViews(with alarm: Alarm) {
        alarmNameLabel.text = alarm.name
        alarmTimeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
}
