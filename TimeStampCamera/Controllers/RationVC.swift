//
//  RationVC.swift
//  TimeStampCamera
//
//  Created by macOS on 14/04/22.
//

import UIKit

class RatioVC: UIViewController {
    
    let Ratio:[UIModel] = [
        UIModel(icon: ShortCutsAssets.Ratio.image, title: "Ration"),
        UIModel(icon: ShortCutsAssets.Focus.image, title: "Focus"),
        UIModel(icon: ShortCutsAssets.Sound.image, title: "Sound")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
