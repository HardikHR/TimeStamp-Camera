//
//  ShortcutVCViewController.swift
//  TimeStampCamera
//
//  Created by macOS on 13/04/22.
//

import UIKit
import CoreImage

class ShortcutVC: UIViewController {
    let tableview = UITableView()

    let ShortCust:[UIModel] = [
        UIModel(icon: ShortCutsAssets.Ratio.image, title: "Ratio"),
        UIModel(icon: ShortCutsAssets.Focus.image, title: "Focus"),
        UIModel(icon: ShortCutsAssets.Sound.image, title: "Sound")
    ]
    var selectedIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableview.isScrollEnabled = false
        tableview.frame.size = view.frame.size
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ShortcutTableViewCell", bundle: nil), forCellReuseIdentifier: "shortcutCell")
        view.addSubview(tableview)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userDefaults.integer(forKey: "shortcuts_isSaved")
    }
}

extension ShortcutVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShortCust.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shortcutCell", for: indexPath) as! ShortcutTableViewCell
        let Index = ShortCust[indexPath.row]
        cell.lblTitle.font = .systemFont(ofSize: 20, weight: .semibold)

        if (selectedIndex == indexPath) {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnisSelected.setImage(UIImage(named: ""), for: .normal)
        }
        cell.SoundSwitch.isHidden = false

        if indexPath.row == 2 {
            cell.imgIcon.image = Index.icon
            cell.lblTitle.text = Index.title
            cell.btnisSelected.isHidden = true
        }else{
            cell.imgIcon.image = Index.icon
            cell.lblTitle.text = Index.title
            cell.btnisSelected.isHidden = true
            cell.SoundSwitch.isHidden = true
        }
        if userDefaults.integer(forKey: "shortcuts_isSaved") == indexPath.row {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.bottomSheet(controller: RatioVC(), width: view.frame.width, height: 320)
        }else if indexPath.row == 1{
            self.bottomSheet(controller: FocusVC(), width: view.frame.width, height: 220)
        }
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "shortcuts_isSaved")
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
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
        btnCancel.pin(top: nil, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor, centerX: footerView.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 10, bottom: 2, right: 10), size: .init(width: 30, height: 45))
        return footerView
    }
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return UITableViewHeaderFooterView.headerView(width: self.view.frame.width, height: tableview.rowHeight, text: "ShortCuts")
    }
}
