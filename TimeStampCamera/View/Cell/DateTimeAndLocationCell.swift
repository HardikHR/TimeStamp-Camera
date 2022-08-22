//
//  DateTimeTableViewCell.swift
//  TimeStampCamera
//
//  Created by macOS on 08/04/22.
//

import UIKit

class DateTimeAndLocationCell: UITableViewCell {

    @IBOutlet weak var imgDTIcons: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var dtSwitch: UISwitch!
    @IBOutlet weak var dateTimeIconView: UIView!
    @IBOutlet weak var dateTimeTitleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateTimeIconView.dropShadow()
        dateTimeTitleView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
