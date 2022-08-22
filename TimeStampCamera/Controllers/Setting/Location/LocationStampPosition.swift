//
//  LocationStampPosition.swift
//  TimeStampCamera
//
//  Created by macOS on 26/04/22.
//

import UIKit

class LocationStampPosition: UIViewController {

    @IBOutlet weak var VerticalView: UIView!
    @IBOutlet weak var HorizontalView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var varticalSlider: UISlider!
    @IBOutlet weak var HorizontalSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stamp Position"
        VerticalView.dropShadow()
        topView.dropShadow()
        HorizontalView.dropShadow()
        HorizontalSlider.thumbImage(for: .normal)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
