//
//  AssistiveGridVCViewController.swift
//  TimeStampCamera
//
//  Created by macOS on 13/04/22.
//

import UIKit

class AssistiveGridVC: UIViewController {
    let tableview = UITableView()
    
   let gridLine = GridViews()
    let Assistive:[UIModel] = [
        UIModel(icon: AssistiveGridAssets.Grid_Off.image, title: "OFF"),
        UIModel(icon: AssistiveGridAssets.CameraGrid.image, title: "Draw_3X3"),
        UIModel(icon: AssistiveGridAssets.Draw_4x4.image, title: "Draw_4X4"),
        UIModel(icon: AssistiveGridAssets.Draw_phi.image, title: "Draw_phi")
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
        print("viewWillAppear_AssistiveGridVC")
        userDefaults.integer(forKey: "Grid_isSaved")
    }
   
}

extension AssistiveGridVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Assistive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shortcutCell", for: indexPath) as! ShortcutTableViewCell
        cell.imgIcon.image = Assistive[indexPath.row].icon
        cell.lblTitle.text = Assistive[indexPath.row].title
        cell.lblTitle.font = .systemFont(ofSize: 20, weight: .semibold)

        if (selectedIndex == indexPath) {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnisSelected.setImage(UIImage(named: ""), for: .normal)
        }
        cell.SoundSwitch.isHidden = true
        if userDefaults.integer(forKey: "Grid_isSaved") == indexPath.row {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let index = ["index":indexPath.row]
        NotificationCenter.default.post(name:NSNotification.Name.gridLines,object: nil,userInfo: index)
        userDefaults.set(indexPath.row, forKey: "gridLines")
        self.dismiss(animated: true)
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "Grid_isSaved")
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
       return UITableViewHeaderFooterView.headerView(width: self.view.frame.width, height: tableview.rowHeight, text: "Assistive Grid")
    }
}
