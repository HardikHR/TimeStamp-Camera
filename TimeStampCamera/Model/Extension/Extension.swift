//
//  DesignModel.swift
//  TimeStampCamera
//
//  Created by macOS on 07/04/22.
//

import AVFoundation
import UIKit
import MaterialComponents.MaterialBottomSheet

extension UIImageView{
    convenience init(placeHolderImage: UIImage? = nil){
        self.init(image: placeHolderImage)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
    }
}

extension UILabel {
    convenience init(text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil, textAlligment: NSTextAlignment? = nil) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlligment ?? .left
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
    
extension UIViewController {
     func bottomSheet(controller:UIViewController, width:CGFloat, height:CGFloat){
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: controller)
        bottomSheet.preferredContentSize = CGSize(width: width, height: height)
        let shape = MDCCurvedRectShapeGenerator(cornerSize: CGSize(width: 8, height: 8))
        bottomSheet.setShapeGenerator(shape, for: .preferred)
        bottomSheet.setShapeGenerator(shape, for: .extended)
        bottomSheet.setShapeGenerator(shape, for: .closed)
        bottomSheet.dismissOnDraggingDownSheet = true
        self.present(bottomSheet, animated: true, completion: nil)
    }
}

extension UIButton {
    class func CancelButton(text:String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.2067943215, green: 0.4772849679, blue: 0.9982356429, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.isUserInteractionEnabled = true
        button.setTitle(text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension UITableView {
    class func reuseTableView(size:CGSize, identifier:String, nibName:String) -> UITableView {
        let table = UITableView()
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.frame.size = size
        table.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
        return table
    }
}

extension UITableViewHeaderFooterView {
    class func headrerView(view:UIView, cornerRadius:CGFloat = 0) {
        if let headerView = view as? Self {
            headerView.textLabel?.textColor = #colorLiteral(red: 0.2067943215, green: 0.4772849679, blue: 0.9982356429, alpha: 1)
            headerView.textLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.contentView.backgroundColor = .white
            headerView.layer.cornerRadius = cornerRadius
            headerView.backgroundView?.backgroundColor = .black
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        }
    }
    class func headerView(width:CGFloat, height:CGFloat, text:String)->UIView {
        let footerView = UIView()
        let lab = UILabel()
        lab.text = text
        lab.textColor = #colorLiteral(red: 0.2067943215, green: 0.4772849679, blue: 0.9982356429, alpha: 1)
        lab.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        footerView.addSubview(lab)
        lab.pin(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        footerView.backgroundColor = .systemBackground
        footerView.frame = CGRect(x: 0, y: 0, width: width, height:height)
        return footerView
    }
    
    class func footerView(width:CGFloat, height:CGFloat)->UIView {
        let footerView = UIView()
        footerView.backgroundColor = .systemBackground
        footerView.frame = CGRect(x: 0, y: 0, width: width, height:height)
        return footerView
    }
}

extension UIViewController {
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-140, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(1)
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UserDefaults {
    //MARK:- COLOR -

    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
    }
    
    //MARK:- FONT -
    func font(forKey key : String) -> UIFont?{
        guard let fontName = string(forKey: key + "_name") else { return nil }
        let fontSize = float(forKey: key + "_size")
        if fontSize == 0.0 { return nil }
        return UIFont(name: fontName, size: CGFloat(fontSize))
    }
    func set(font : UIFont, forKey key : String){
        let fontName = font.fontName
        let fontSize = font.pointSize
        self.set(fontName, forKey: key + "_name")
        self.set(Float(fontSize), forKey: key + "_size")
    }

}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}


func hexStringFromUIColor(color: UIColor) -> String {
    let components = color.cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0
    let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    print(hexString)
    return hexString
 }

extension Date{
    func dateToStringConverter(dateFormat : String = "dd/MM/yy hh:mm a") -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = dateFormat
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)!
        
        formatter.dateFormat = dateFormat
        let showDate = formatter.string(from: yourDate)
        if dateFormat == "yyyy-MM-dd HH:mm:ss.SSS" {
            formatter.dateFormat = "hh:mm:ss a"
        }
        else{
            formatter.dateFormat = ""
        }
        let showTime = formatter.string(from: yourDate)
        return showDate + " " + showTime
    }
}

func lati(short : Bool = false, medium : Bool = false, long : Bool = false) -> String {//"%.5f°%@","%.0f°%.5f'%@","%.0f°%.0f'%.5f\"%@"
    var latitudeSeconds = Global.shared.latitude * 3600
    let latitudeDegrees = latitudeSeconds / 3600
    latitudeSeconds = latitudeSeconds.truncatingRemainder(dividingBy: 3600)
    let latitudeMinutes = latitudeSeconds / 60
    latitudeSeconds = latitudeSeconds.truncatingRemainder(dividingBy: 60)
    let latitudeCardinalDirection = latitudeDegrees >= 0 ? "N" : "S"
    var latitudeDescription = ""
    if short {
    latitudeDescription = String(format: "%.5f°%@",
                                         abs(latitudeDegrees), latitudeCardinalDirection)
    }else if medium {
    latitudeDescription = String(format: "%.0f°%.5f'%@",
                                         abs(latitudeDegrees), abs(latitudeMinutes),latitudeCardinalDirection)
    }else  if long{
    latitudeDescription = String(format: "%.0f°%.0f'%.5f\"%@",
                                         abs(latitudeDegrees), abs(latitudeMinutes),
                                         abs(latitudeSeconds), latitudeCardinalDirection)
    }
    return latitudeDescription
    //%.2f° %.2f' %.2f\" %@
}

func longi(short : Bool = false, medium : Bool = false, long : Bool = false) -> String {//"%.5f°%@","%.0f°%.5f'%@","%.0f°%.0f'%.5f\"%@"
    var longitudeSeconds = Global.shared.longitude * 3600
    
    let longitudeDegrees = longitudeSeconds / 3600
    
    longitudeSeconds = longitudeSeconds.truncatingRemainder(dividingBy: 3600)
    
    let longitudeMinutes = longitudeSeconds / 60
    longitudeSeconds = longitudeSeconds.truncatingRemainder(dividingBy: 60)
    
    let longitudeCardinalDirection = longitudeDegrees >= 0 ? "E" : "W"
    
    
    var latitudeDescription = ""
    if short {
    latitudeDescription = String(format: "%.5f°%@",
                                         abs(longitudeDegrees), longitudeCardinalDirection)
    }else if medium {
    latitudeDescription = String(format: "%.0f°%.5f'%@",
                                 abs(longitudeDegrees), abs(longitudeMinutes), longitudeCardinalDirection)
    }else  if long{
    latitudeDescription = String(format: "%.0f°%.0f'%.5f\"%@",
                                 abs(longitudeDegrees), abs(longitudeMinutes),
                                 abs(longitudeSeconds), longitudeCardinalDirection)
    }
    return latitudeDescription
    //%.4f° %.2f' %.2f\" %@
}

extension UIViewController {
    static func instantiateFromStoryboard(_ name: String = "Main", _ identifier: String? = nil) -> Self {
//        currentViewController = identifier
        func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let id = identifier ?? String(describing: self)
            let controller = storyboard.instantiateViewController(withIdentifier: id) as! T
            return controller
        }
        return instantiateFromStoryboardHelper(name)
    }
}

extension UIViewController {
    static func instantiate(from storyboard:String, identifier: String? = nil) -> Self {
        return instantiateFromStoryboard(storyboard, identifier)
    }
}

enum Storyboards {
    static let  Main = "Main"
}

extension UIView {
    struct AnchoredConstraints {
        var top, leading, bottom, trailing,centerX,centerY, width, height: NSLayoutConstraint?
    }
    @discardableResult
    func pin(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?,centerX: NSLayoutXAxisAnchor?,centerY: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        if let centerX = centerX {
                   anchoredConstraints.centerX = centerXAnchor.constraint(equalTo: centerX, constant: padding.left)
               }
        if let centerY = centerY {
            anchoredConstraints.centerY = centerYAnchor.constraint(equalTo: centerY, constant: padding.top)
                     }
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height,anchoredConstraints.centerX, anchoredConstraints.centerY].forEach{ $0?.isActive = true }
        return anchoredConstraints
    }
}

extension FileManager {
    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}
extension AVCaptureDevice.FocusMode: CustomStringConvertible {
    public var description: String {
        var string: String
        
        switch self {
        case .locked:
            string = "Locked"
        case .autoFocus:
            string = "Auto"
        case .continuousAutoFocus:
            string = "ContinuousAuto"
        }
        
        return string
    }
}

extension AVCaptureDevice.ExposureMode: CustomStringConvertible {
    public var description: String {
        var string: String
        
        switch self {
        case .locked:
            string = "Locked"
        case .autoExpose:
            string = "Auto"
        case .continuousAutoExposure:
            string = "ContinuousAuto"
        case .custom:
            string = "Custom"
        }
        
        return string
    }
}

extension AVCaptureDevice.WhiteBalanceMode: CustomStringConvertible {
    public var description: String {
        var string: String
        
        switch self {
        case .locked:
            string = "Locked"
        case .autoWhiteBalance:
            string = "Auto"
        case .continuousAutoWhiteBalance:
            string = "ContinuousAuto"
        }
        
        return string
    }
}
