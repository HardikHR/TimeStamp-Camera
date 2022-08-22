//
//  SettingScreen.swift
//  TimeStampCamera
//
//  Created by USER on 28/05/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    
    
    @IBOutlet weak var lblDateTimeOnOff: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblDateTimeShow: UILabel!
    @IBOutlet weak var imgSettingIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
