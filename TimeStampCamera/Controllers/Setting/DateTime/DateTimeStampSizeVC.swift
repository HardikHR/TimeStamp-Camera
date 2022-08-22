//
//  DateTimeStampSizeVC.swift
//  TimeStampCamera
//
//  Created by macOS on 22/04/22.
//

import UIKit

class DateTimeStampSize: UIViewController {
    
    @IBOutlet weak var stampSizeTableview: UITableView!
    let StampSizeInt = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
    var selectedIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stampSizeTableview.delegate = self
        stampSizeTableview.dataSource = self
        stampSizeTableview.register(UINib(nibName: "DateTimeFormatTableViewCell", bundle: nil), forCellReuseIdentifier: "stampSizeCell")
        view.addSubview(stampSizeTableview)
        let StampSizeSave = UIBarButtonItem(image: UIImage(named:"tick"), style: .done, target: self, action: #selector(didTapSave))
        self.navigationItem.rightBarButtonItem = StampSizeSave
    }
    
    @objc func didTapSave(){
        let StampSizes = StampSizeInt[selectedIndex?.row ?? 0]
        userDefaults.set(StampSizes, forKey: "fontSize")
        self.navigationController?.popViewController(animated: true)
        print("save")
    }
}

extension DateTimeStampSize:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StampSizeInt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stampSizeCell", for: indexPath) as! DateTimeFormatTableViewCell
        cell.lblFontSize.text = StampSizeInt[indexPath.row].description
        cell.lblFontSize.layer.backgroundColor = UIColor.orange.cgColor
        cell.lblFontSize.clipsToBounds = true
        cell.lblFontSize.layer.masksToBounds = true
        cell.lblDateFormate.text = Date().dateToStringConverter(dateFormat: datetime_format[2])
        cell.lblDateFormate.font = cell.lblDateFormate.font.withSize(CGFloat(indexPath.row))
        
        /*cell.lblFontSize.layer.borderWidth = 1
        cell.lblFontSize.layer.masksToBounds = false
        cell.lblFontSize.layer.borderColor = UIColor.black.cgColor
        cell.lblFontSize.layer.cornerRadius = cell.lblFontSize.frame.height/2
        cell.lblFontSize.clipsToBounds = true*/
        
        if (selectedIndex == indexPath) {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnIsselect.setImage(UIImage(named: ""), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let row = indexPath.row
        print(StampSizeInt[row])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
