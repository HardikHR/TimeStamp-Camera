//
//  GridView.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 28/04/22.
//

import UIKit

class GridViews: UIView {
    var numberOfColumns: Int = 1
    var numberOfRows: Int = 1
    var lineWidth: CGFloat = 0.5
    var lineColor: UIColor = UIColor.white

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(lineWidth)
            context.setStrokeColor(UIColor.white.cgColor)

            let columnWidth = Int(rect.width) / (numberOfColumns + 1)
            for i in 0...numberOfColumns {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = CGFloat(columnWidth * i)
                startPoint.y = 0.0
                endPoint.x = startPoint.x
                endPoint.y = frame.size.height
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }

            let rowHeight = Int(rect.height) / (numberOfRows + 1)
            for j in 0...numberOfRows {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = 0.0
                startPoint.y = CGFloat(rowHeight * j)
                endPoint.x = frame.size.width
                endPoint.y = startPoint.y
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
    }
}
