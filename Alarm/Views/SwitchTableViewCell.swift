//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class{
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

weak var delegate: SwitchTableViewCellDelegate?

class SwitchTableViewCell: UITableViewCell {
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else {return}
            updateViews(alarm: alarm)
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    func updateViews(alarm: Alarm) {
        nameLabel.text = alarm.name
        titleLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.isEnabled
    }
}
