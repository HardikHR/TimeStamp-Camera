//
//  TimerVC.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 04/04/22.
//

import UIKit

class TimerVC: UIViewController {
    
    let tableview = UITableView()

    let timer:[UIModel] = [
        UIModel(icon: TimerAssets.Timer_3Sec.image, title: "3 Sec"),
        UIModel(icon: TimerAssets.Timer_5Sec.image, title: "5 Sec"),
        UIModel(icon: TimerAssets.timer.image, title: "OFF"),
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
        userDefaults.integer(forKey: "timer_isSaved")
    }

}

extension TimerVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shortcutCell", for: indexPath) as! ShortcutTableViewCell
        
        
        if cell.isSelected  {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
    
        cell.imgIcon.image = timer[indexPath.row].icon
        cell.lblTitle.text = timer[indexPath.row].title
        cell.lblTitle.font = .systemFont(ofSize: 20, weight: .semibold)

        if (selectedIndex == indexPath) {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnisSelected.setImage(UIImage(named: ""), for: .normal)
        }
        cell.SoundSwitch.isHidden = true
        if userDefaults.integer(forKey: "timer_isSaved") == indexPath.row {
            cell.btnisSelected.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            userDefaults.set(indexPath.row, forKey: "setTimer")
            self.dismiss(animated: true, completion: nil)
        }else if indexPath.row == 1 {
            userDefaults.set(indexPath.row, forKey: "setTimer")
            self.dismiss(animated: true, completion: nil)
        }else if indexPath.row == 2 {
            userDefaults.set(indexPath.row, forKey: "setTimer")
            self.dismiss(animated: true, completion: nil)
        }
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "timer_isSaved")
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
       return UITableViewHeaderFooterView.headerView(width: self.view.frame.width, height: tableview.rowHeight, text: "Timer")
    }
}
