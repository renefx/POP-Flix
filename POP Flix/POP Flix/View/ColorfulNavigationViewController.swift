//
//  ColorfulNavigationViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class ColorfulNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors: [UIColor] = Color.colorArray
        setColorsNavigationBarShadow(colors)
        setNavigationBarFont()
    }
    
    func setNavigationBarFont() {
        if let font = UIFont(name: Font.fontMedium, size: 16) {
            let attributes = [NSAttributedString.Key.font: font]
            self.navigationBar.titleTextAttributes = attributes
        }
    }
    
    func setColorsNavigationBarShadow(_ colors: [UIColor]) {
        let image = UIImage()
        
        let shadowHeight: CGFloat = 2
        let shadowWidth: CGFloat = self.screenWidth / CGFloat(colors.count)
        
        UIGraphicsBeginImageContext(CGSize(width: self.screenWidth, height: shadowHeight))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        image.draw(at: CGPoint.zero)
        
        for (index, color) in colors.enumerated() {
            let newXPosition = shadowWidth * CGFloat(index)
            let rectangle = CGRect(x: newXPosition, y: 0, width: shadowWidth, height: shadowHeight)
            context.setFillColor(color.cgColor)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationBar.shadowImage = newImage
        
    }
    
}
