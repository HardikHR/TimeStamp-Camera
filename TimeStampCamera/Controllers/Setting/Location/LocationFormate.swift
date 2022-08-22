//
//  LocationFormateVC.swift
//  TimeStampCamera
//
//  Created by macOS on 18/04/22.
//

import UIKit
import DropDown
import CoreLocation
class LocationFormate: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var Choosedrop: UIButton!
    let chooseDropDown = DropDown()
    
    var selectedIndex:IndexPath?
    var locatioManeger = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        chooseDropDown.anchorView = Choosedrop
        chooseDropDown.dataSource = ["\(lati(short: true)) \(longi(short: true))", "\(lati(medium: true)) \(longi(medium: true))","\(lati(long: true)) \(longi(long: true))"]
        chooseDropDown.direction = .bottom
        chooseDropDown.backgroundColor = .white
        chooseDropDown.topOffset = CGPoint(x: 0, y: Choosedrop.bounds.height)
        chooseDropDown.selectionBackgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLocation()
        userDefaults.integer(forKey: "locFormat_isSaved")
        Choosedrop.setTitle(userDefaults.string(forKey: "locFormate") ?? "\(lati(short: true)) \(longi(short: true))", for: .normal)
    }
    
    func getLocation(){
        locatioManeger.requestAlwaysAuthorization()
        locatioManeger.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locatioManeger.delegate = self
            locatioManeger.desiredAccuracy = kCLLocationAccuracyBest
            locatioManeger.startUpdatingLocation()
        }
    }
    
    @IBAction func ChooseDropDown(_ sender: UIButton) {
        chooseDropDown.show()
        chooseDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            if index == 0 {
                self?.Choosedrop.setTitle("\(lati(short: true)) \(longi(short: true))", for: .normal)
                let short = "\(lati(short: true)) \(longi(short: true))"
                userDefaults.set(short, forKey: "locFormate")
            }else if index == 1 {
                self?.Choosedrop.setTitle("\(lati(medium: true)) \(longi(medium: true))", for: .normal)
                let medium = "\(lati(medium: true)) \(longi(medium: true))"
                userDefaults.set(medium, forKey: "locFormate")
            }else if index == 2 {
                self?.Choosedrop.setTitle("\(lati(long: true)) \(longi(long: true))", for: .normal)
                let long = "\(lati(long: true)) \(longi(long: true))"
                userDefaults.set(long, forKey: "locFormate")
            }
        }
        chooseDropDown.width = 330
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
    
    @IBAction func didTapSave(_ sender: UIButton) {
        if selectedIndex?.row == 0 {
            userDefaults.integer(forKey: "locFormate")
        }else if selectedIndex?.row == 1 {
            userDefaults.integer(forKey: "locFormate")
        }else if selectedIndex?.row == 2 {
            userDefaults.integer(forKey: "locFormate")
        }
        print("saved")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

