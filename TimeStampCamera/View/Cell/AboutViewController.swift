//
//  AboutViewController.swift
//  TimeStampCamera
//
//  Created by macOS on 02/05/22.
//

import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
