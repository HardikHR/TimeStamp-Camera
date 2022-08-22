//
//  DateTimeFormateViewController.swift
//  TimeStampCamera
//
//  Created by macOS on 07/04/22.
//

import UIKit

class DateTimeFormate: UIViewController {
    var isFirst = false
    var tag = 0
    @IBOutlet weak var DateTimeFormatTableView: UITableView!
    var select:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirst = true
        title = "Date & Time Format"
        DateTimeFormatTableView.register(UINib(nibName: "DateTimeFormatTableViewCell", bundle: nil), forCellReuseIdentifier: "dateFormetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userDefaults.integer(forKey: "dtFormat_isSaved")
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let formate = datetime_format[select?.row ?? 0]
        userDefaults.set(formate, forKey: "format")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DateTimeFormate:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datetime_format.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateFormetCell", for: indexPath) as! DateTimeFormatTableViewCell
        cell.lblFontSize.isHidden = true
        cell.selectionStyle = .none

        cell.dateFormatView.backgroundColor = .systemGray6
        cell.lblDateFormate.font = .systemFont(ofSize: 18, weight: .semibold)
        cell.numberView.isHidden = true

        cell.lblDateFormate.text = Date().dateToStringConverter(dateFormat: datetime_format[indexPath.row])
        if isFirst {
           
        }
        if (select == indexPath) {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnIsselect.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "dtFormat_isSaved") == indexPath.row {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        select = indexPath
        userDefaults.set(select![1], forKey: "dtFormat_isSaved")
        tableView.reloadData()
    }
}

