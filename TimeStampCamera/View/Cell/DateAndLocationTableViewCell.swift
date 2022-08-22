//
//  TableViewCell.swift
//  TimeStampCamera
//
//  Created by USER on 27/05/22.
//

import UIKit

class DateAndLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDTIcons: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var dtSwitch: UISwitch!
    @IBOutlet weak var dateTimeIconView: UIView!
    @IBOutlet weak var dateTimeTitleView: UIView!

    @IBOutlet weak var locationOnView: UIView!
    @IBOutlet weak var ImglocationIcon: UIImageView!
    @IBOutlet weak var lblLocationSubTitle: UILabel!
    
    @IBOutlet weak var locationOnOff: UISwitch!
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var btnIsSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateTimeIconView.dropShadow()
        dateTimeTitleView.dropShadow()
        locationOnView.dropShadow()
    }
}
