//
//  SettingViewController.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 04/04/22.
//

import UIKit
import StoreKit
import CoreLocation

class SettingViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var settingTableView: UITableView!
    var locatioManeger = CLLocationManager()
    let general:[UIModel] = [
        UIModel(icon: settingImageAssets.DateTime.image, title: "Date & Time"),
        UIModel(icon: settingImageAssets.Locations.image, title: "Location")
    ]
    var loca = ""
    var firstTimeAppLaunch: Bool {
        get {return userDefaults.bool(forKey: "firstTimeLaunch")}
    }
    let Support:[UIModel] = [
        UIModel(icon: settingImageAssets.ChooseFolder.image, title: "Choose Folder"),
        UIModel(icon: settingImageAssets.RateApp.image, title: "Rate App"),
        UIModel(icon: settingImageAssets.ShareApp.image, title: "Share App"),
        UIModel(icon: settingImageAssets.PrivacyPolicy.image, title: "Privacy Policy"),
        UIModel(icon: settingImageAssets.AboutApp.image, title: "About App")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !firstTimeAppLaunch {
            userDefaults.set(true, forKey: "firstTimeLaunch")
            userDefaults.set(false, forKey: "isDatetimes")
        }
        settingTableView.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        title = "Setting"
        
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear_SettingViewController")
        settingTableView.reloadData()
        userDefaults.bool(forKey: "isLocation")
        UserDefaults.standard.string(forKey: "locFormate")
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        }else{
            return Support.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.lblDateTime.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.lblDateTimeShow.font = .systemFont(ofSize: 14, weight: .medium)
        cell.backgroundColor = .systemGray6
        cell.iconView.backgroundColor = .systemGray6
        cell.settingView.backgroundColor = .systemGray6
        cell.lblHeader.isHidden = false
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.lblDateTimeOnOff.isHidden = false
            cell.lblDateTimeShow.isHidden = false
            cell.imgSettingIcon.image = general[indexPath.row].icon
            cell.lblDateTime.text = general[indexPath.row].title
            if userDefaults.bool(forKey: "isDatetime") == true {
                cell.lblDateTimeOnOff.text = "ON"
            }
            
            if Global.shared.isDateTime == true {
                cell.lblDateTimeOnOff.text = "ON"
            }else{
                cell.lblDateTimeOnOff.text = "OFF"
                cell.lblDateTimeOnOff.textColor = .systemGray4
            }
            
            if indexPath.row == 0 {
                cell.lblDateTimeShow.isHidden = false
                
                if let dateform = UserDefaults.standard.string(forKey: "format") {
                    let date = Date().dateToStringConverter(dateFormat: dateform)
                    cell.lblDateTimeShow.text = date
                }else {
                    cell.lblDateTimeShow.text = Date().dateToStringConverter(dateFormat: "dd/MM/yy hh:mm a")
                    cell.lblDateTimeOnOff.text = "ON"
                }
                cell.lblHeader.isHidden = false
                cell.imgSettingIcon.image = general[indexPath.row].icon
                cell.lblDateTime.text = general[indexPath.row].title
                cell.lblHeader.font = .systemFont(ofSize: 17, weight: .bold)
                cell.lblHeader.textColor = .systemBlue
                cell.lblHeader.text = "General"
                cell.lblDateTimeOnOff.font = .systemFont(ofSize: 15, weight: .semibold)
                cell.lblDateTimeOnOff.textColor = .systemBlue
                if Global.shared.isDateTime == true {
                    cell.lblDateTimeOnOff.text = "ON"
                }else{
                    cell.lblDateTimeOnOff.text = "OFF"
                    cell.lblDateTimeOnOff.textColor = .systemGray4
                }
            }else if indexPath.row == 1 {
                cell.lblDateTimeOnOff.font = .systemFont(ofSize: 15, weight: .semibold)
                cell.lblDateTimeOnOff.textColor = .systemBlue
                cell.lblHeader.isHidden = true
                cell.lblDateTimeShow.text = "Location"
                if CLLocationManager.locationServicesEnabled() {
                    switch locatioManeger.authorizationStatus {
                    case .authorizedAlways, .authorizedWhenInUse:
                        if let dateform = userDefaults.string(forKey: "locFormate") {
                            cell.lblDateTimeShow.text = dateform
                        }else {
                            cell.lblDateTimeShow.text = "\(lati(short: true)) \(longi(short: true))"
                        }
                    case .notDetermined, .restricted, .denied:
                      print("denide")
                    @unknown default:
                        break
                    }
                } else {
                    locaShare()
                }
                
                if Global.shared.isLocation == true {
                    cell.lblDateTimeOnOff.text = "ON"
                }else{
                    cell.lblDateTimeOnOff.text = "OFF"
                    cell.lblDateTimeOnOff.textColor = .systemGray4
                }
                if userDefaults.bool(forKey: "isLocation") == true{
                    cell.lblDateTimeOnOff.text = "ON"
                    cell.lblDateTimeOnOff.textColor = .systemBlue
                }
//                if let dateform = userDefaults.string(forKey: "locFormate") {
//                    cell.lblDateTimeShow.text = dateform
//                }else {
//                    cell.lblDateTimeShow.text = "Location"
//                }
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.lblHeader.font = .systemFont(ofSize: 17, weight: .bold)
                cell.lblHeader.textColor = .systemBlue
                cell.lblHeader.text = "Support"
                cell.imgSettingIcon.image = Support[indexPath.row].icon
                cell.lblDateTime.text = Support[indexPath.row].title
                cell.lblDateTimeOnOff.isHidden = true
                cell.lblDateTimeShow.isHidden = true
            }else {
                cell.lblHeader.isHidden = true
                cell.imgSettingIcon.image = Support[indexPath.row].icon
                cell.lblDateTime.text = Support[indexPath.row].title
                cell.lblDateTimeOnOff.isHidden = true
                cell.lblDateTimeShow.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let dateTimeVc = MainDateTime.instantiateFromStoryboard()
                navigationController?.pushViewController(dateTimeVc, animated: true)
            } else if indexPath.row == 1 {
                onLocation()
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let chooseFolderVC = ChooseFolderVC.instantiateFromStoryboard()
                navigationController?.pushViewController(chooseFolderVC, animated: true)
            }else if indexPath.row == 1 {
                    rateApp()
            }else if indexPath.row == 2 {
                if let name = URL(string: "https://itunes.apple.com/us/app/myapp/id959379869?ls=1&mt=8"), !name.absoluteString.isEmpty {
                  let objectsToShare = [name]
                  let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                  self.present(activityVC, animated: true, completion: nil)
                }
            }else if indexPath.row == 3 {
                let privacyPoli = PrivacyPolicy.instantiateFromStoryboard()
               // let PrivacyPolicy = PrivacyPolicy.instantiateFromStoryboard()
                navigationController?.pushViewController(privacyPoli, animated: true)
            }else if indexPath.row == 4 {
                let aboutVc = AboutViewController.instantiateFromStoryboard()
                navigationController?.pushViewController(aboutVc, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        let latit = locValue.latitude
        let longit = locValue.longitude
        let latVal = String(format:"%.4f", latit)
        let longVal = String(format:"%.4f", longit)
        Global.shared.longitude = Double(latVal)!
        Global.shared.latitude = Double(longVal)!
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                break
            }
        } else {
            hasPermission = false
        }
        return hasPermission
    }
    
    private func onLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch locatioManeger.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let locVC = MainLocation.instantiateFromStoryboard("Location", "MainLocation")
                navigationController?.pushViewController(locVC, animated: true)
            case .notDetermined, .restricted, .denied:
                if !hasLocationPermission() {
                    self.locaShare()
                    let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            @unknown default:
                break
            }
        } else {
            locaShare()
        }
    }
    
    private func locaShare(){
        locatioManeger.requestAlwaysAuthorization()
        locatioManeger.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locatioManeger.delegate = self
            locatioManeger.desiredAccuracy = kCLLocationAccuracyBest
            locatioManeger.startUpdatingLocation()
        }
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "https://itunes.apple.com/fr/app/hipster-moustache/id959379869?mt=8") {
            DispatchQueue.main.async {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

    

