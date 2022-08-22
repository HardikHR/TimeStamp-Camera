//
//  DateTimeStampSizeVC.swift
//  TimeStampCamera
//
//  Created by macOS on 25/04/22.
//

import UIKit

class LocationTimeStampSize: UIViewController {
    
    @IBOutlet weak var stampSizeTableview: UITableView!
    let StampSizeInt = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
    var selectedIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stampSizeTableview.delegate = self
        stampSizeTableview.dataSource = self
        stampSizeTableview.register(UINib(nibName: "DateTimeFormatTableViewCell", bundle: nil), forCellReuseIdentifier: "locStampSizeCell")
        view.addSubview(stampSizeTableview)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let StampSizes = StampSizeInt[selectedIndex?.row ?? 0]
        userDefaults.set(StampSizes, forKey: "locFontSize")
        self.navigationController?.popViewController(animated: true)
        print("save")
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        stampSizeTableview.reloadData()
        userDefaults.integer(forKey: "locStampSize_isSaved")
    }
}

extension LocationTimeStampSize:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StampSizeInt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locStampSizeCell", for: indexPath) as! DateTimeFormatTableViewCell
        cell.lblFontSize.text = StampSizeInt[indexPath.row].description
        cell.lblDateFormate.text = Date().dateToStringConverter(dateFormat: datetime_format[2])
        cell.lblDateFormate.font = .systemFont(ofSize: CGFloat(StampSizeInt[indexPath.row]), weight: .semibold)
        cell.dateFormatView.backgroundColor = .systemGray6
        cell.numberView.backgroundColor = .systemGray6
        cell.selectionStyle = .none

        cell.lblFontSize.layer.backgroundColor = UIColor.white.cgColor
        cell.lblFontSize.layer.masksToBounds = true
        cell.lblFontSize.layer.cornerRadius = cell.lblFontSize.frame.size.height/2
        cell.lblFontSize.layer.borderWidth = 1
        cell.lblFontSize.layer.borderColor = UIColor.clear.cgColor
        cell.lblFontSize.clipsToBounds = true

        if (selectedIndex == indexPath) {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnIsselect.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "locStampSize_isSaved") == indexPath.row {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "locStampSize_isSaved")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
