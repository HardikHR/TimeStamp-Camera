//
//  Global.swift
//  TimeStampCamera
//
//  Created by macOS on 11/04/22.
//

import UIKit

class Global: NSObject {
    static var shared = Global()
    var isFirst = false
    var isDateTime = true
    var isLocation = false
    var cornerRadius = false
    var latitude = 0.0
    var longitude = 0.0
    var Gridimage:UIImage?
}

extension Notification.Name {
    static let gridLines = Notification.Name("gridLines")
    static let whiteBalance = Notification.Name("whiteBalance")
    static let flashOnOff = Notification.Name("flashOnOf")
    static let focusMode = Notification.Name("focusMode")
}

let userDefaults = UserDefaults.standard

struct savePosition:Codable {
    let xPos:Float
    let yPos:Float
}

