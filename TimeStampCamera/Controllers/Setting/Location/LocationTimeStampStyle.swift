//
//  DateTimeStampStyle.swift
//  TimeStampCamera
//
//  Created by macOS on 25/04/22.
//

import UIKit

class LocationTimeStampStyle: UIViewController {
    
    @IBOutlet weak var stampStyleTableview: UITableView!

    var selectedIndex:IndexPath?
    let fontStyle = ["Roboto-Regular","AmaticSC-Regular","Cabin-Regular","DS-Digital","DancingScript-Regular","NewWaltograph","Felipa-Regular","Julee-Regular","OctinPrisonRg","PatrickHand-Regular","ReenieBeanie","Tillana-Regular","Yellowtail-Regular","OldStamper","WetPet-Regular"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stampStyleTableview.delegate = self
        stampStyleTableview.dataSource = self
        stampStyleTableview.register(UINib(nibName: "DateTimeFormatTableViewCell", bundle: nil), forCellReuseIdentifier: "LocStampStyleCell")
        view.addSubview(stampStyleTableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userDefaults.integer(forKey: "locStampStyle_isSaved")
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let StampStyle = fontStyle[selectedIndex?.row ?? 0]
        userDefaults.set(StampStyle, forKey: "locStampStyle")
        self.navigationController?.popViewController(animated: true)
        print("save")
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension LocationTimeStampStyle:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fontStyle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocStampStyleCell", for: indexPath) as! DateTimeFormatTableViewCell
        cell.lblDateFormate.text = fontStyle[indexPath.row]
        cell.lblDateFormate.font = UIFont(name: fontStyle[indexPath.row], size: 20)
        cell.lblFontSize.isHidden = true
        cell.numberView.backgroundColor = .systemGray6
        cell.dateFormatView.backgroundColor = .systemGray6
        cell.numberView.isHidden = true
        cell.selectionStyle = .none

        
        if (selectedIndex == indexPath) {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        } else {
            cell.btnIsselect.setImage(UIImage(named: ""), for: .normal)
        }
        if userDefaults.integer(forKey: "locStampStyle_isSaved") == indexPath.row {
            cell.btnIsselect.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        userDefaults.set(selectedIndex![1], forKey: "locStampStyle_isSaved")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
