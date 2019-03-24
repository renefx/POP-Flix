//
//  ColorfulLine.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class ColorfulLine: UIImageView {
    var colors: [UIColor] = []
    var lineHeight: CGFloat = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(colors: [UIColor], frame: CGRect){
        self.init(frame: frame)
        self.lineHeight = frame.height
        addLine(colors: colors, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addLine(colors: [UIColor], frame: CGRect) {
        self.colors = colors
        self.image = drawLine()
    }
    
    private func drawLine() -> UIImage? {
        let image = UIImage()
        
        let shadowWidth: CGFloat = self.frame.width / CGFloat(colors.count)
        
        UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: lineHeight))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        image.draw(at: CGPoint.zero)
        
        for (index, color) in colors.enumerated() {
            let newXPosition = shadowWidth * CGFloat(index)
            let rectangle = CGRect(x: newXPosition, y: 0, width: shadowWidth, height: lineHeight)
            context.setFillColor(color.cgColor)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
