//
//  UIimageVuew Extension.swift
//  TimeStampCamera
//
//  Created by macOS on 15/04/22.
//

import Foundation
import UIKit

extension UIImageView {
    
    enum ImageAddingMode {
        case changeOriginalImage
        case addSubview
        case addCopiedSubview
    }
    
    func drawOnCurrentImage<T: UIView>(view: T, mode: ImageAddingMode, editSubviewClosure: @escaping UIImage.EditSubviewClosure<T>) {
        
        guard let image = image else {
            return
        }
        let addSubView: (T) -> () = { view in
            editSubviewClosure(self.frame.size, view)
            self.addSubview(view)
        }
        switch mode {
        case .changeOriginalImage:
            self.image = image.with(view: view, editSubviewClosure: editSubviewClosure)
        case .addSubview:
            addSubView(view)
        case .addCopiedSubview:
            if let copiedView = view.copyObject() as? T {
                addSubView(copiedView)
            }
        }
    }
}


extension UIImage {
    
    typealias EditSubviewClosure<T: UIView> = (_ parentSize: CGSize, _ viewToAdd: T)->()
    
    func with<T: UIView>(view: T, editSubviewClosure: EditSubviewClosure<T>) -> UIImage {
        
        if let copiedView = view.copyObject() as? T {
            UIGraphicsBeginImageContext(size)
            let basicSize = CGRect(origin: .zero, size: size)
            draw(in: basicSize)
            editSubviewClosure(size, copiedView)
            copiedView.draw(basicSize)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return self
    }
}

extension UIView {
    func copyObject<T: UIView> () -> T? {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? T
    }
}
