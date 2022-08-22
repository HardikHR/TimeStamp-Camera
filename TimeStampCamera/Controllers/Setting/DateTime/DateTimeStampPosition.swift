//
//  DateTimeStampPosition.swift
//  TimeStampCamera
//
//  Created by macOS on 26/04/22.
//

import UIKit

class DateTimeStampPosition: UIViewController {

    @IBOutlet weak var VerticalView: UIView!
    @IBOutlet weak var HorizontalView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var positionView: UIView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var varticalSlider: UISlider!
    @IBOutlet weak var HorizontalSlider: UISlider!
    let postion = ["Top - Left Horizontal","Top - Right Horizontal",
                   "Top - Right Vertical","Bottom - Right Vertical",
                   "Bottom - Right Horizontal","Bottom - Left Horizontal",
                   "Bottom - Left Vertical","Top - Left Vertical"]
    
    var currValue = 0
    var currValue2 = 0
    var selectedIndex = 0
    let textlabels = UILabel(text: "hello", font: UIFont(name: "Helvetica", size: 20), textColor: nil, textAlligment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stamp Position"
        textlabels.backgroundColor = .brown
        VerticalView.dropShadow()
        topView.dropShadow()
        HorizontalView.dropShadow()
        HorizontalSlider.thumbImage(for: .normal)
        positionView.addSubview(textlabels)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let pointValue = NSCoder.string(for: CGPoint(x: positionView.frame.origin.x+330, y: 5))
        userDefaults.set(pointValue, forKey: "coord1")
        //let point = NSCoder.cgRect(for: UserDefaults.value(forKey: "coord1") as! String)
        self.navigationController?.popViewController(animated: true)
        print("save")
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func StickerPosition(ConstraintAttribute1: NSLayoutConstraint.Attribute = .top, constant1: CGFloat = 0, ConstraintAttribute2: NSLayoutConstraint.Attribute = .leading, constant2: CGFloat = 0) {
        self.positionView.addSubview(textlabels)
        textlabels.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: textlabels, attribute: ConstraintAttribute1, relatedBy: NSLayoutConstraint.Relation.equal, toItem: positionView, attribute: ConstraintAttribute1, multiplier: 1, constant: constant1)
        let verticalConstraint = NSLayoutConstraint(item: textlabels, attribute: ConstraintAttribute2, relatedBy: NSLayoutConstraint.Relation.equal, toItem: positionView, attribute: ConstraintAttribute2, multiplier: 1, constant: constant2)
        let widthConstraint = NSLayoutConstraint(item: textlabels, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 150)
        let heightConstraint = NSLayoutConstraint(item: textlabels, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
        self.positionView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    @IBAction func btnLeft(_ sender: UIButton) {
        selectedIndex += 1
        for i in 0...7 {
            if selectedIndex > i {
                lblPosition.text = postion[i]
                print(i)
                if i == 0 {
                    textlabels.frame = CGRect(x:positionView.frame.origin.x+330, y: 5, width: textlabels.frame.size.width, height: textlabels.frame.size.height)
                } else if i == 1 {
                    textlabels.frame = CGRect(x:positionView.frame.origin.x+330, y: positionView.frame.origin.y+300, width: textlabels.frame.size.width, height: textlabels.frame.size.height)
                }else if i == 2 {
                    textlabels.frame = CGRect(x: 5, y: 530, width: textlabels.frame.size.width, height: textlabels.frame.size.height)
                }else if i == 3 {
                    textlabels.frame = CGRect(x: 5, y: 5, width: textlabels.frame.size.width, height: textlabels.frame.size.height)
                }
            }
        }
    }
    
    //textlabels.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)

    @IBAction func btnRight(_ sender: UIButton) {
        selectedIndex -= 1
        for i in 0...7 {
            if selectedIndex > i {
                lblPosition.text = postion[selectedIndex]
                print(i)
                if i == 2 {
                    textlabels.pin(top: nil, leading: positionView.leadingAnchor, bottom: positionView.bottomAnchor, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 0, left: 5, bottom: 5, right: 0),size: .init(width: 150, height: 20))
                }else if i == 1 {
                    textlabels.pin(top: nil, leading: nil, bottom: positionView.bottomAnchor, trailing: positionView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 5, right: 5), size: .init(width: 150, height: 20))
                }else if i == 0 {
                    textlabels.pin(top: positionView.topAnchor, leading: positionView.leadingAnchor, bottom: positionView.bottomAnchor, trailing: positionView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 5, left: 430, bottom: 430, right: 5))
                    //textlabels.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                }
            }
        }
    }
    
    @IBAction func verticalSlider(_ sender: UISlider) {
        textlabels.frame.origin = CGPoint(x: Int(sender.value), y: currValue2)
        currValue = Int(sender.value)
    }
    
    @IBAction func horizontalSlider(_ sender: UISlider) {
        textlabels.frame.origin = CGPoint(x: currValue, y: Int(sender.value))
        currValue2 = Int(sender.value)
    }
}


