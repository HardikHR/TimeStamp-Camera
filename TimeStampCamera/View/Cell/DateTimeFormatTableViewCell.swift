//
//  DateTimeFormatTableViewCell.swift
//  TimeStampCamera
//
//  Created by macOS on 07/04/22.
//

import UIKit

class DateTimeFormatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateFormate: UILabel!
    @IBOutlet weak var btnIsselect: UIButton!
    @IBOutlet weak var dateFormatView: UIView!
    @IBOutlet weak var lblFontSize: UILabel!
    
    @IBOutlet weak var numberView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatView.dropShadow()
    }
}
