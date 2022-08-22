//
//  FlashScreenVC.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 04/04/22.
//

import UIKit
import AVFoundation
class FlashScreenVC: UIViewController{
    let tableview = UITableView()

    let Flash:[UIModel] = [
        UIModel(icon: FlashAssets.flashOff.image, title: "OFF"),
        UIModel(icon: FlashAssets.flash.image, title: "ON"),
        UIModel(icon: FlashAssets.FlashAuto.image, title: "Auto"),
        UIModel(icon: FlashAssets.flashAlwaysOn.image, title: "Always On")
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
        userDefaults.integer(forKey: "Flash_isSaved")
    }
}

extension FlashScreenVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Flash.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shortcutCell", for: indexPath) as! ShortcutTableViewCell
        cell.contentView.bounds = view.bounds
        cell.imgIcon.image = Flash[indexPath.row].icon
        cell.lblTitle.text = Flash[indexPath.row].title
        cell.btnisSelected.tag = indexPath.row
        cell.lblTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        if (selectedIndex == indexPath) {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnisSelected.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "Flash_isSaved") == indexPath.row {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        cell.SoundSwitch.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "Flash_isSaved")
        if indexPath.row == 0 {
//            UserDefaults.standard.set(indexPath.row, forKey: "flashOnOff")
//            self.dismiss(animated: true, completion: nil)
            toggleTorch(on: false, auto: .off)
            self.dismiss(animated: true, completion: nil)

        }else if indexPath.row == 1 {
            UserDefaults.standard.set(indexPath.row, forKey: "flashOnOff")
            self.dismiss(animated: true, completion: nil)
        }else if indexPath.row == 2 {
            UserDefaults.standard.set(indexPath.row, forKey: "flashOnOff")
            self.dismiss(animated: true, completion: nil)
        }else if indexPath.row == 3 {
//            UserDefaults.standard.set(indexPath.row, forKey: "flashOnOff")
            self.dismiss(animated: true, completion: nil)
            toggleTorch(on: true, auto: .on)

        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return UITableViewHeaderFooterView.headerView(width: self.view.frame.width, height: tableview.rowHeight, text: "Flash")
    }
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- FLASH SETUP -

extension FlashScreenVC {
    
    func toggleTorch(on: Bool=false, auto:AVCaptureDevice.FlashMode = .auto) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
