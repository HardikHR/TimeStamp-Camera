//
//  ChooseFolderVC.swift
//  TimeStampCamera
//
//  Created by macOS on 13/04/22.
//

import UIKit

class ChooseFolderVC: UIViewController {
    
    @IBOutlet weak var ChooseFolderTableview: UITableView!
   
    let ChooseFolder:[UIModel] = [
        UIModel(icon: settingImageAssets.ChooseFolder.image, title: "Default"),
        UIModel(icon: settingImageAssets.ChooseFolder.image, title: "Site 1"),
        UIModel(icon: settingImageAssets.ChooseFolder.image, title: "Site 2")
    ]
    let storagePath = ["Storage","/Storage/DCIM/Camera/TimeStamp/Site1","/Storage/DCIM/Camera/TimeStamp/Site2"]

    var selectedIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseFolderTableview.backgroundColor = .white
        title = "Choose Folder"
        self.navigationController?.isNavigationBarHidden = true
        ChooseFolderTableview.register(UINib(nibName: "ChooseFolder", bundle: nil), forCellReuseIdentifier: "ChooseFolderCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userDefaults.integer(forKey: "chooseFolder_isSaved")
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        print("saved")
        let selectStorage = storagePath[selectedIndex?.row ?? 0]
        userDefaults.set(selectStorage, forKey: "selectedStorege")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChooseFolderVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChooseFolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseFolderCell", for: indexPath) as! ChooseFolder
        cell.lblTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.lblSubTitle.font = .systemFont(ofSize: 14, weight: .medium)
        
        cell.imgFolderIcon.image = ChooseFolder[indexPath.row].icon
        cell.lblTitle.text = ChooseFolder[indexPath.row].title
        cell.lblSubTitle.text = storagePath[indexPath.row]
        cell.backgroundColor = .systemGray6
        
        if (selectedIndex == indexPath) {
            cell.btnIsSelect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnIsSelect.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "chooseFolder_isSaved") == indexPath.row {
            cell.btnIsSelect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "chooseFolder_isSaved")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
    }
}
