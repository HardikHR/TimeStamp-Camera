//
//  ColorAssets.swift
//  TimeStampCamera
//
//  Created by macOS on 08/04/22.
//

import Foundation
import UIKit

enum colorAssets {
    static let CameraiconColor = UIColor(named: "CameraiconColor") ?? UIColor.clear
    static let CameraNavigaion = UIColor(named: "CameraNavigaion") ?? UIColor.clear
    static let SettingNavigation = UIColor(named: "SettingNavigation") ?? UIColor.clear
    static let TimeDateLabelColor = UIColor(named: "TimeDateLabelColor") ?? UIColor.clear
    static let VideoStartColor = UIColor(named: "VideoStartColor") ?? UIColor.clear
}

enum Chech_Unchek {
    case Radiobutton
    case deselected
    var image:UIImage {
        switch self {
        case .Radiobutton: return UIImage(named: "Radiobutton") ?? UIImage()
        case .deselected: return UIImage(named: "deselected") ?? UIImage()
        }
    }
}

enum settingImageAssets {
    case DateTime
    case Locations
    case ChooseFolder
    case RateApp
    case ShareApp
    case PrivacyPolicy
    case AboutApp
    
    var image:UIImage {
        switch self {
        case .DateTime: return UIImage(named: "DateTime") ?? UIImage()
        case .Locations: return UIImage(named: "Locations") ?? UIImage()
        case .ChooseFolder: return UIImage(named: "Select_Folder") ?? UIImage()
        case .RateApp: return UIImage(named: "Rate_us") ?? UIImage()
        case .ShareApp: return UIImage(named: "ShreApp") ?? UIImage()
        case .PrivacyPolicy: return UIImage(named: "PrivecyPolicy") ?? UIImage()
        case .AboutApp: return UIImage(named: "AboutUs") ?? UIImage()
        }
    }
}

enum DataTimeAndLocationImgAssets {
    case Stamp_back_color
    case StampColor
    case StampPosition
    case StampSize
    case StampStyle
    
    var image:UIImage {
        switch self {
        case .Stamp_back_color: return UIImage(named: "Stamp_back_color") ?? UIImage()
        case .StampColor: return UIImage(named: "StampColor") ?? UIImage()
        case .StampPosition: return UIImage(named: "StampPosition") ?? UIImage()
        case .StampSize: return UIImage(named: "StampSize") ?? UIImage()
        case .StampStyle: return UIImage(named: "StampStyle") ?? UIImage()
        }
    }
}

enum ShortCutsAssets {
    case Focus
    case Sound
    case Ratio
    var image:UIImage {
        switch self {
        case .Focus: return UIImage(named: "Focus") ?? UIImage()
        case .Sound: return UIImage(named: "Sound") ?? UIImage()
        case .Ratio: return UIImage(named: "Ratio") ?? UIImage()
        }
    }
}

enum TimerAssets {
    case Timer_3Sec
    case Timer_5Sec
    case timer

    var image:UIImage {
        switch self {
        case .Timer_3Sec: return UIImage(named: "Timer_3Sec") ?? UIImage()
        case .Timer_5Sec: return UIImage(named: "Timer_5Sec") ?? UIImage()
        case .timer: return UIImage(named: "timer") ?? UIImage()
        }
    }
}

enum FlashAssets {
    case flash
    case flashOff
    case FlashAuto
    case flashAlwaysOn
    
    var image:UIImage {
        switch self {
        case .flash: return UIImage(named: "flash") ?? UIImage()
        case .flashOff: return UIImage(named: "flashOff") ?? UIImage()
        case .FlashAuto: return UIImage(named: "FlashAuto") ?? UIImage()
        case .flashAlwaysOn: return UIImage(named: "flashAlwaysOn") ?? UIImage()
        }
    }
}

enum AssistiveGridAssets {
    case Grid_Off
    case CameraGrid
    case Draw_4x4
    case Draw_phi

    var image:UIImage {
        switch self {
        case .Grid_Off: return UIImage(named: "Grid_Off") ?? UIImage()
        case .CameraGrid: return UIImage(named: "CameraGrid") ?? UIImage()
        case .Draw_4x4: return UIImage(named: "Draw_4x4") ?? UIImage()
        case .Draw_phi: return UIImage(named: "Draw_phi") ?? UIImage()

        }
    }
}

enum WhiteBalanceAssets {
    case White_Balance
    case Incandescebt
    case Fluorescent
    case DayLight
    case Cloudy

    var image:UIImage {
        switch self {
        case .White_Balance: return UIImage(named: "White_Balance") ?? UIImage()
        case .Incandescebt: return UIImage(named: "Incandescebt") ?? UIImage()
        case .Fluorescent: return UIImage(named: "Fluorescent") ?? UIImage()
        case .DayLight: return UIImage(named: "DayLight") ?? UIImage()
        case .Cloudy: return UIImage(named: "Cloudy") ?? UIImage()
        }
    }
}

enum RatioAssets {
    case One_Six_Nine
    case Four_Three
    case One_one
    case Full

    var image:UIImage {
        switch self {
        case .One_Six_Nine: return UIImage(named: "16-9") ?? UIImage()
        case .Four_Three: return UIImage(named: "4-3") ?? UIImage()
        case .One_one: return UIImage(named: "1-1") ?? UIImage()
        case .Full: return UIImage(named: "full") ?? UIImage()
        }
    }
}

enum FoucsAssets {
    case Auto
    case Touch

    var image:UIImage {
        switch self {
        case .Auto: return UIImage(named: "Auto") ?? UIImage()
        case .Touch: return UIImage(named: "Touch") ?? UIImage()
        }
    }
}

struct UIModel {
    let icon:UIImage
    let title:String
}

extension UIView {
    func dropShadow() {
        backgroundColor = UIColor.systemBackground
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
    }
}

let datetime_format = ["dd/MM/yy",
                       "dd/MM/yy HH:mm",
                       "dd/MM/yy hh:mm a",
                       "dd/MM/yy hh:mm:ss a",
                       "dd/MM/yyyy",
                       "dd/MM/yyyy HH:mm",
                       "dd/MM/yyyy hh:mm a",
                       "dd/MM/yyyy hh:mm:ss a",
                       "MM/dd/yy",
                       "MM/dd/yy HH:mm",
                       "MM/dd/yy hh:mm a",
                       "MM/dd/yy hh:mm:ss a",
                       "MM/dd/yyyy",
                       "MM/dd/yyyyHH:mm",
                       "MM/dd/yyyy hh:mm",
                       "MM/dd/yyyy hh:mm:ss",
                       "yyyy/MM/dd HH:mm",
                       "yyyy/MM/dd hh:mm",
                       "yyyy/MM/ddhh:mm:ss",
                       "yyyyMMdd",
                       "dd.MM.yy",
                       "dd.MM.yy HH:mm",
                       "dd.MM.yy hh:mm a",
                       "dd.MM.yy hh:mm:ss a",
                       "dd.MM.yyyy",
                       "dd.MM.yyyy HH:mm",
                       "dd.MM.yyyy hh:mm",
                       "dd.MM.yyyy hh:mm:ss a",
                       "MM.dd.yy",
                       "MM.dd.yy HH:mm a",
                       "MM.dd.yy hh:mm",
                       "MM.dd.yy hh:mm:ss",
                       "MM.dd.yyyy a",
                       "MM.dd.yyyy HH:mm a",
                       "MM.dd.yyyy hh:mm a",
                       "MM.dd.yyyy hh:mm:ss a",
                       "dd/MMM/yyyy",
                       "dd/MMM/yyyy HH:mm",
                       "dd MMM, yyyy a",
                       "dd MMM, yyyy HH:mm",
                       "dd MMM, yyyy hh:mm a",
                       "dd MMM yyyy",
                       "dd MMM yyyy HH:mm",
                       "dd MMM yyyy hh:mm a",
                       "dd MMMM, yyyy",
                       "dd MMMM, yyyy HH:mm",
                       "dd MMMM, yyyy hh:mm a",
                       "dd MMMM yyyy",
                       "dd MMMM yyyy HH:mm",
                       "dd MMMM yyyy hh:mm a",
                       "MMM dd, yyyy",
                       "MMM dd, yyyy HH:mm",
                       "MMM dd, yyyy hh:mm a",
                       "MMMM dd, yyyy",
                       "MMMM dd, yyyy HH:mm",
                       "MMMM dd, yyyy hh:mm a",
                       "EEE, dd MMM yyyy",
                       "EEE, dd MMM yyyy HH:mm",
                       "EEE, dd MMMyyyyhh:mm a",
                       "EEE, dd MMMM yyyy",
                       "EEE, dd MMMM yyyy HH:mm",
                       "EEE, dd MMMM yyyy hh:mm a",
                       "EEEE, dd MMM yyyy",
                       "EEEE, dd MMM yyyy HH:mm",
                       "EEEE, dd MMM yyyy hh:mm a",
                       "EEEE, dd MMMM yyyy",
                       "EEEE, dd MMMM yyyy HH:mm",
                       "EEEE, dd MMMM yyyy hh:mm a"]
