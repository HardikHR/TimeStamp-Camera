//
//  WhiteBalanceVC.swift
//  TimeStampCamera
//
//  Created by macOS on 13/04/22.
//

import UIKit

class WhiteBalanceVC: UIViewController {
    let tableview = UITableView()

    let WhiteBalance:[UIModel] = [
        UIModel(icon: WhiteBalanceAssets.White_Balance.image, title: "Auto"),
        UIModel(icon: WhiteBalanceAssets.Incandescebt.image, title: "Incandescent"),
        UIModel(icon: WhiteBalanceAssets.Fluorescent.image, title: "Fluorescent"),
        UIModel(icon: WhiteBalanceAssets.DayLight.image, title: "Daiylight"),
        UIModel(icon: WhiteBalanceAssets.Cloudy.image, title: "Cloudy")
    ]
    var selectedIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableview.separatorStyle = .none
        tableview.isScrollEnabled = false
        tableview.frame.size = view.bounds.size
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ShortcutTableViewCell", bundle: nil), forCellReuseIdentifier: "shortcutCell")
        view.addSubview(tableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userDefaults.integer(forKey: "whiteBalance_isSaved")
    }
}
extension WhiteBalanceVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WhiteBalance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shortcutCell", for: indexPath) as! ShortcutTableViewCell
        cell.imgIcon.image = WhiteBalance[indexPath.row].icon
        cell.lblTitle.text = WhiteBalance[indexPath.row].title
        cell.lblTitle.font = .systemFont(ofSize: 20, weight: .semibold)

        cell.SoundSwitch.isHidden = true
        if (selectedIndex == indexPath) {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnisSelected.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "whiteBalance_isSaved") == indexPath.row {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath

        userDefaults.set(selectedIndex![1], forKey: "whiteBalance_isSaved")
        let index = ["index":indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name.whiteBalance, object: nil, userInfo: index)
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UITableViewHeaderFooterView.footerView(width: self.view.frame.width, height: tableview.rowHeight)
        let btnCancel = UIButton.CancelButton(text: "CLOSE")
        btnCancel.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        footerView.addSubview(btnCancel)
        btnCancel.pin(top: nil, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor, centerX: footerView.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 30, height: 45))
        return footerView
    }
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return UITableViewHeaderFooterView.headerView(width: self.view.frame.width, height: tableview.rowHeight, text: "White balance")
    }
}


/*
 @IBAction func changeWhiteBalanceMode(_ control: UISegmentedControl) {
     let mode = self.whiteBalanceModes[control.selectedSegmentIndex]
     
     do {
         try self.videoDevice!.lockForConfiguration()
         if self.videoDevice!.isWhiteBalanceModeSupported(mode) {
             self.videoDevice!.whiteBalanceMode = mode
         } else {
             NSLog("White balance mode %@ is not supported. White balance mode is %@.", mode.description, self.videoDevice!.whiteBalanceMode.description)
             self.whiteBalanceModeControl.selectedSegmentIndex = self.whiteBalanceModes.firstIndex(of: self.videoDevice!.whiteBalanceMode)!
         }
         self.videoDevice!.unlockForConfiguration()
     } catch let error {
         NSLog("Could not lock device for configuration: \(error)")
     }
 }
 
 private func setWhiteBalanceGains(_ gains: AVCaptureDevice.WhiteBalanceGains) {
     do {
         try self.videoDevice!.lockForConfiguration()
         let normalizedGains = self.normalizedGains(gains) // Conversion can yield out-of-bound values, cap to limits
         self.videoDevice!.setWhiteBalanceModeLocked(with: normalizedGains, completionHandler: nil)
         self.videoDevice!.unlockForConfiguration()
     } catch let error {
         NSLog("Could not lock device for configuration: \(error)")
     }
 }
 
 @IBAction func changeTemperature(_: AnyObject) {
     let temperatureAndTint = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(
         temperature: self.temperatureSlider.value,
         tint: self.tintSlider.value)
     self.setWhiteBalanceGains(self.videoDevice!.deviceWhiteBalanceGains(for: temperatureAndTint))
 }
 
 @IBAction func changeTint(_: AnyObject) {
     let temperatureAndTint = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(
         temperature: self.temperatureSlider.value,
         tint: self.tintSlider.value
     )
     
     self.setWhiteBalanceGains(self.videoDevice!.deviceWhiteBalanceGains(for: temperatureAndTint))
 }
 
 @IBAction func lockWithGrayWorld(_: AnyObject) {
     self.setWhiteBalanceGains(self.videoDevice!.grayWorldDeviceWhiteBalanceGains)
 }
 
 private func normalizedGains(_ gains: AVCaptureDevice.WhiteBalanceGains) -> AVCaptureDevice.WhiteBalanceGains {
     var g = gains
     
     g.redGain = max(1.0, g.redGain)
     g.greenGain = max(1.0, g.greenGain)
     g.blueGain = max(1.0, g.blueGain)
     
     g.redGain = min(self.videoDevice!.maxWhiteBalanceGain, g.redGain)
     g.greenGain = min(self.videoDevice!.maxWhiteBalanceGain, g.greenGain)
     g.blueGain = min(self.videoDevice!.maxWhiteBalanceGain, g.blueGain)
     
     return g
 }
 */
