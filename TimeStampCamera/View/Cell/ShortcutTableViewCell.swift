//
//  ShortcutCellTableViewCell.swift
//  TimeStampCamera
//
//  Created by macOS on 13/04/22.
//

import UIKit
class ShortcutTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var SoundSwitch: UISwitch!
    @IBOutlet weak var btnisSelected: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
