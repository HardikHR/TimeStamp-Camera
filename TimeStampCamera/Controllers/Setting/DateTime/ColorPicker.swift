//
//  ColorPickerVC.swift
//  TimeStampCamera
//
//  Created by macOS on 20/04/22.
//

import UIKit
import SwiftColorWheel

class ColorPicker: UIViewController, ColorWheelDelegate {
    
    @IBOutlet weak var cornerRadisView: UIView!
    @IBOutlet weak var colorPickerView: ColorWheel!
    @IBOutlet weak var colorview: UIView!
    @IBOutlet weak var ColorResult: UIView!
    @IBOutlet weak var lblHexResult: UILabel!
    @IBOutlet weak var swCornerRadius: UISwitch!
    
    @IBOutlet weak var opticitySlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    var colors = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorview.backgroundColor = .systemGray6

        title = "Stamp Background Color"
        colorview.dropShadow()
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
        if let color = userDefaults.color(forKey: "dtLabelColor") {
            ColorResult.backgroundColor = color
        }
        swCornerRadius.isOn = userDefaults.bool(forKey: "isCornerRadius")
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        userDefaults.set(colors, forKey: "dtLabelColor")
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dtlblCornerRadius(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "isCornerRadius")
    }
    
    @IBAction func opticitySlider(_ sender: UISlider) {
        colorPickerView.brightness = CGFloat(sender.value)
    }
    
    @IBAction func alphaSlider(_ sender: UISlider) {
        colorPickerView.alpha = CGFloat(sender.value)
    }
    
    func didSelect(color: UIColor) {
        colors = color
        ColorResult.backgroundColor = color
        lblHexResult.text = hexStringFromUIColor(color: color)
        
        opticitySlider.thumbTintColor = colors
        opticitySlider.minimumTrackTintColor = colors
        
        alphaSlider.thumbTintColor = colors
        alphaSlider.minimumTrackTintColor = colors
    }
}
