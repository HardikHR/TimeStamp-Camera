//
//  DateTimeVC.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 05/04/22.
//

import UIKit

class DateTime: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var dateTimeTableview: UITableView!
    //let userDefault = UserDefaults.standard
    
    var firstTimeAppLaunch: Bool {
        get {return userDefaults.bool(forKey: "firstTimeAppLaunch")}
    }
    var lblcolor = UIColor.clear
    let dtItems:[UIModel] = [
        UIModel(icon: settingImageAssets.DateTime.image, title: "Date & Time"),
        UIModel(icon: settingImageAssets.DateTime.image, title: "Date & Time Format"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampPosition.image, title: "Stamp Position"),
        UIModel(icon: DataTimeAndLocationImgAssets.Stamp_back_color.image, title: "Stamp Background Color"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampColor.image, title: "Stamp Color"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampSize.image, title: "Stamp Size"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampStyle.image, title: "Stamp Style")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Date & Time"
        if !firstTimeAppLaunch {
            userDefaults.set(true, forKey: "firstTimeAppLaunch")
            userDefaults.set(false, forKey: "isDatetime")
        }
        dateTimeTableview.register(UINib(nibName: "DateTimeAndLocationCell", bundle: nil), forCellReuseIdentifier: "dateTimeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.dateTimeTableview.reloadData()
    }
}

extension DateTime:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dtItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateTimeCell", for: indexPath) as! DateTimeAndLocationCell
        let index = dtItems[indexPath.row]
        if indexPath.row == 0 {
            cell.lblSubTitle.layer.borderWidth = 0

            cell.dtSwitch.isHidden = false
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.addTarget(self, action: #selector(valueChange), for: .valueChanged)
            cell.dtSwitch.isOn = userDefaults.bool(forKey: "isDatetime")
            if cell.dtSwitch.isOn == true {
                cell.lblSubTitle.text = "ON"
            }else{
                cell.lblSubTitle.text = "OFF"
            }
        }else if indexPath.row == 1{
            cell.lblSubTitle.layer.borderWidth = 0
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
            if let dateform = userDefaults.string(forKey: "format") {
            let date = Date().dateToStringConverter(dateFormat: dateform)
                cell.lblSubTitle.text = date
            }
        }else if indexPath.row == 3{
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
            cell.lblSubTitle.layer.borderWidth = 3
            cell.lblSubTitle.frame.size.height = 50
            cell.lblSubTitle.layer.cornerRadius = 5
            if let color = userDefaults.color(forKey: "dtLabelColor"){
                cell.lblSubTitle.layer.borderColor = color.cgColor
            }
        }else if indexPath.row == 4{
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
            if let dateform = userDefaults.string(forKey: "format") {
            let date = Date().dateToStringConverter(dateFormat: dateform)
                cell.lblSubTitle.text = date
            }
            if let textColor = userDefaults.color(forKey: "dtTxtColor"){
                cell.lblSubTitle.textColor = textColor
            }
        }else if indexPath.row == 5{
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
            let fontSize = userDefaults.integer(forKey: "fontSize")
            cell.lblSubTitle.text = String(fontSize)
        }else if indexPath.row == 6{
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
            if let fontStyle = userDefaults.string(forKey: "stampStyle") {
                cell.lblSubTitle.font = UIFont(name: fontStyle, size:14)
            }
            if let dateform = userDefaults.string(forKey: "format") {
            let date = Date().dateToStringConverter(dateFormat: dateform)
                cell.lblSubTitle.text = date
            }
        }else{
            cell.lblSubTitle.layer.borderWidth = 0
            cell.imgDTIcons.image = index.icon
            cell.lblTitle.text = index.title
            cell.dtSwitch.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let dateformat = DateTimeFormate.instantiateFromStoryboard()
            self.navigationController?.pushViewController(dateformat, animated: true)
        }else if indexPath.row == 2 {
            let datePisition = DateTimeStampPosition.instantiateFromStoryboard()
            self.navigationController?.pushViewController(datePisition, animated: true)
        }else if indexPath.row == 3 {
            let colorPik = ColorPicker.instantiateFromStoryboard()
            self.navigationController?.pushViewController(colorPik, animated: true)
        }else if indexPath.row == 4 {
            let StampColor = DateTimeStampColor.instantiateFromStoryboard()
            self.navigationController?.pushViewController(StampColor, animated: true)
        }else if indexPath.row == 5 {
            let StampSize = DateTimeStampSize.instantiateFromStoryboard()
            self.navigationController?.pushViewController(StampSize, animated: true)
        }else if indexPath.row == 6 {
            let StampStyle = DateTimeStampStyle.instantiateFromStoryboard()
            self.navigationController?.pushViewController(StampStyle, animated: true)
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        lblcolor = color
    }
    
    @objc func valueChange(sender:UISwitch){
        userDefaults.set(sender.isOn, forKey: "isDatetime")
        Global.shared.isDateTime = userDefaults.bool(forKey: "isDatetime")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
