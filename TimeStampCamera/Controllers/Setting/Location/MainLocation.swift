//
//  locationVc.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 05/04/22.
//

import UIKit
import CoreLocation

class MainLocation: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationTableView: UITableView!
    let locationManager = CLLocationManager()
 
    var firstAppLaunch: Bool {
        get {return userDefaults.bool(forKey: "firstAppLaunch")}
        set {}
    }
    
    let locationItems:[UIModel] = [
        UIModel(icon: settingImageAssets.Locations.image, title: "Location"),
        UIModel(icon: settingImageAssets.Locations.image, title: "Location Format"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampPosition.image, title: "Stamp Position"),
        UIModel(icon: DataTimeAndLocationImgAssets.Stamp_back_color.image, title: "Stamp Background Color"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampColor.image, title: "Stamp Color"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampSize.image, title: "Stamp Size"),
        UIModel(icon: DataTimeAndLocationImgAssets.StampStyle.image, title: "Stamp Style")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        if !firstAppLaunch {
            userDefaults.set(true, forKey: "firstAppLaunch")
            userDefaults.set(true, forKey: "isLocation")
        }
        locationTableView.register(UINib(nibName: "DateAndLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "locationCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.locationTableView.reloadData()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MainLocation:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! DateAndLocationTableViewCell
        let locItem = locationItems[indexPath.row]
        cell.lblTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.lblSubTitle.textColor = .gray
        cell.lblSubTitle.font = .systemFont(ofSize: 14, weight: .medium)
        cell.locationOnView.isHidden = true
        cell.selectionStyle = .none
        cell.locationOnView.backgroundColor = .systemGray6
        cell.dateTimeIconView.backgroundColor = .systemGray6
        cell.dateTimeTitleView.backgroundColor = .systemGray6
        if indexPath.row == 0 {
            cell.lblLocationSubTitle.font = .systemFont(ofSize: 15, weight: .semibold)
            cell.lblLocationSubTitle.textColor = .systemBlue
            cell.locationOnView.isHidden = false
            cell.btnIsSelect.isHidden = true
            cell.dateTimeIconView.isHidden = true
            cell.dateTimeTitleView.isHidden = true
            cell.lblLocationTitle.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.ImglocationIcon.image = UIImage(named: "Locations")
            cell.lblLocationTitle.text = "Location"
            cell.lblLocationSubTitle.text = "ON"
            cell.locationOnOff.addTarget(self, action: #selector(valueChange), for: .valueChanged)
            cell.locationOnOff.isOn = userDefaults.bool(forKey: "isLocation")
            if cell.locationOnOff.isOn == true {
                cell.lblLocationSubTitle.text = "ON"
            }else{
                cell.lblLocationSubTitle.text = "OFF"
                cell.lblLocationSubTitle.textColor = .systemGray4
            }
        }else if indexPath.row == 1 {
            cell.dateTimeIconView.isHidden = false
            cell.dateTimeTitleView.isHidden = false
            cell.lblSubTitle.layer.borderWidth = 0
            cell.imgDTIcons.image = locItem.icon
            cell.lblTitle.text = locItem.title
            cell.dtSwitch.isHidden = true
            if let dateform = userDefaults.string(forKey: "locFormate") {
                cell.lblSubTitle.text = dateform
            }else {
                cell.lblSubTitle.text = "\(lati(short: true)) \(longi(short: true))"
            }
        }else if indexPath.row == 3 {
            cell.dateTimeIconView.isHidden = false
            cell.dateTimeTitleView.isHidden = false
            cell.lblSubTitle.text = "\t\t\t"
            cell.imgDTIcons.image = locItem.icon
            cell.lblTitle.text = locItem.title
            cell.dtSwitch.isHidden = true
            cell.lblSubTitle.layer.borderWidth = 3
            cell.lblSubTitle.frame.size.height = 15
            cell.lblSubTitle.layer.cornerRadius = 2
            if let color = userDefaults.color(forKey: "LocLabelColor"){
                cell.lblSubTitle.layer.borderColor = color.cgColor
            }
        }else if indexPath.row == 4 {
            cell.dateTimeIconView.isHidden = false
            cell.dateTimeTitleView.isHidden = false
            cell.imgDTIcons.image = locItem.icon
            cell.lblTitle.text = locItem.title
            cell.dtSwitch.isHidden = true
            if let dateform = userDefaults.string(forKey: "locFormate") {
                cell.lblSubTitle.text = dateform
            }else{
                cell.lblSubTitle.text = "\(lati(short: true)) \(longi(short: true))"
            }
            if let textColor = userDefaults.color(forKey: "LocTxtColor"){
                cell.lblSubTitle.textColor = textColor
            }
        }else if indexPath.row == 5{
            cell.dateTimeIconView.isHidden = false
            cell.dateTimeTitleView.isHidden = false

            cell.imgDTIcons.image = locItem.icon
            cell.lblTitle.text = locItem.title
            cell.dtSwitch.isHidden = true
            let fontSize = userDefaults.integer(forKey: "locFontSize")
            cell.lblSubTitle.text = String(fontSize)
            
        }else if indexPath.row == 6{
            cell.dateTimeIconView.isHidden = false
            cell.dateTimeTitleView.isHidden = false
            cell.imgDTIcons.image = locItem.icon
            cell.lblTitle.text = locItem.title
            cell.dtSwitch.isHidden = true
            if let fontStyle = userDefaults.string(forKey: "locStampStyle") {
                cell.lblSubTitle.font = UIFont(name: fontStyle, size:14)
            }
            if let dateform = userDefaults.string(forKey: "locFormate") {
                cell.lblSubTitle.text = dateform
            }else{
                cell.lblSubTitle.text = "\(lati(short: true)) \(longi(short: true))"
            }
        }else{
            cell.imgDTIcons.image = locationItems[indexPath.row].icon
            cell.lblTitle.text = locationItems[indexPath.row].title
            cell.dtSwitch.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let locationformat = LocationFormate.instantiateFromStoryboard("Location", "LocationFormate")
            self.navigationController?.pushViewController(locationformat, animated: true)
        }else if indexPath.row == 2 {
            let locStampPosition = LocationStampPosition.instantiateFromStoryboard("Location", "LocationStampPosition")
            self.navigationController?.pushViewController(locStampPosition, animated: true)
        } else if indexPath.row == 3 {
            let locColor = LocationColorPicker.instantiateFromStoryboard("Location", "LocationColorPicker")
            self.navigationController?.pushViewController(locColor, animated: true)
        }else if indexPath.row == 4 {
            let StampColor = LocationStampColor.instantiateFromStoryboard("Location", "LocationStampColor")
            self.navigationController?.pushViewController(StampColor, animated: true)
        }else if indexPath.row == 5 {
            let StampSize = LocationTimeStampSize.instantiateFromStoryboard("Location", "LocationTimeStampSize")
            self.navigationController?.pushViewController(StampSize, animated: true)
        }else if indexPath.row == 6 {
            let StampStyle = LocationTimeStampStyle.instantiateFromStoryboard("Location", "LocationTimeStampStyle")
            self.navigationController?.pushViewController(StampStyle, animated: true)
        }
    }
    
    @objc func valueChange(sender:UISwitch) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                locaShare()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            locaShare()
        }
        userDefaults.set(sender.isOn, forKey: "isLocation")
        Global.shared.isLocation = userDefaults.bool(forKey: "isLocation")
    }
    
    private func locaShare(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func permissionLocationSettings() {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Alert", message: "Please permision to access location!", preferredStyle:  .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Setting", style: .cancel, handler: { (_ ) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:]) { _ in
                        // stuff
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

