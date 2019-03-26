//
//  ColorPalette.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString:String,_ alpha:CGFloat = 1) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            return nil
        }
    }
    
    var toHexString: String? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            
            let rgb = iRed<<16 | iGreen<<8 | iBlue<<0
            
            return String(format:"#%06x", rgb)
        } else {
            return nil
        }
    }
}

class Color {
    
    static let primary = UIColor(hexString: "2F91FF")
    static let secondary = UIColor(hexString: "FFCC33")
    static let gray = UIColor(hexString: "E1E1E1")
    static let orangeShadow = UIColor(hexString: "FF8847")
    static let blueShadow = UIColor(hexString: "2F91FF")
    static let yellowShadow = UIColor(hexString: "FFCC33")
    static let redShadow = UIColor(hexString: "D73712")
    static let black = "000000"
    
    
    
    static let colorArray: [UIColor] = [
                             Color.orangeShadow,
                             Color.blueShadow,
                             Color.yellowShadow,
                             Color.redShadow]
}

