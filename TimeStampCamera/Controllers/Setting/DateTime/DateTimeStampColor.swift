//
//  ColorPickerVC.swift
//  TimeStampCamera
//
//  Created by macOS on 20/04/22.
//

import UIKit
import SwiftColorWheel
import FlexColorPicker

class DateTimeStampColor: UIViewController, ColorWheelDelegate {
    
    @IBOutlet weak var colorPickerView: ColorWheel!
    @IBOutlet weak var colorview: UIView!
    @IBOutlet weak var ColorResult: UIView!
    @IBOutlet weak var lblHexResult: UILabel!
    
    @IBOutlet weak var opticitySlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    var colors = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stamp Color"
        colorview.dropShadow()
        colorview.backgroundColor = .systemGray6

        lblHexResult.layer.cornerRadius = 5
        lblHexResult.layer.borderWidth = 0.3
        lblHexResult.layer.borderColor = UIColor.gray.cgColor
        
        colorPickerView.delegate = self
        ColorResult.layer.cornerRadius = ColorResult.frame.size.width/2
        ColorResult.clipsToBounds = true
        ColorResult.layer.borderColor = UIColor.white.cgColor
        ColorResult.layer.borderWidth = 3.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let color = userDefaults.color(forKey: "dtTxtColor") {
            ColorResult.backgroundColor = color
        }
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        userDefaults.set(colors, forKey: "dtTxtColor")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func didSelect(color: UIColor) {
        colors = color
        ColorResult.backgroundColor = color
        lblHexResult.text = hexStringFromUIColor(color: color)
    }

    @IBAction func opticitySlider(_ sender: UISlider) {
        colorPickerView.brightness = CGFloat(sender.value)
    }
    
    @IBAction func alphaSlider(_ sender: UISlider) {
        colorPickerView.alpha = CGFloat(sender.value)

    }
}
