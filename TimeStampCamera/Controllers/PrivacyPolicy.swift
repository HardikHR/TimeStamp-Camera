//
//  TearmAndCondition.swift
//  TimeStampCamera
//
//  Created by Nuclues Lab Admin on 03/06/22.
//

import UIKit
import WebKit

class PrivacyPolicy: UIViewController {

    @IBOutlet weak var privacyPolicyView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string: "https://www.google.co.in/")
            let request = URLRequest(url: url!)
        privacyPolicyView.load(request)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
