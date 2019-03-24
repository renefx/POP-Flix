//
//  MovieListSectionHeader.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class MovieListSectionHeader: UIView {
    var topLine: UIView!
    let lineHeight: CGFloat = 1
    let colorfulLineHeight: CGFloat = 2
    var viewColor: UIColor = .white
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addViews(toFrame: frame)
        self.backgroundColor = viewColor
    }
    
    convenience init(width: CGFloat, height: CGFloat, title: String, hideTopLine: Bool = true, color: UIColor = .white){
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.init(frame: frame)
        self.viewColor = color
        self.backgroundColor = viewColor
        self.addViews(toFrame: frame, title: title, hideTopLine: hideTopLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addViews(toFrame: CGRect, title: String = General.none, hideTopLine: Bool = true) {
        
        if !hideTopLine {
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: lineHeight))
            topLine.backgroundColor = Color.gray
            self.addSubview(topLine)
        }
        
        let paddingLeft: CGFloat = 12
        let label = UILabel(frame: CGRect(x: paddingLeft, y: lineHeight, width: frame.width - paddingLeft, height:  frame.height - lineHeight))
        
        if let font = UIFont(name: Font.fontSemibold, size: 14) {
            label.font = font
        }
        label.backgroundColor = viewColor
        label.text = title
        self.addSubview(label)
        
        let lineFrame = CGRect(x: 0, y: frame.height - colorfulLineHeight, width: frame.width, height: colorfulLineHeight)
        let imageView = ColorfulLine(colors: Color.colorArray, frame: lineFrame)
        self.addSubview(imageView)
    }
}
