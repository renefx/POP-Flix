//
//  UIViewControllerExtension.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func setNavBarBackgroundColor(_ color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
    
    func setNavBarTitleItemsColor(_ color: UIColor) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
        self.navigationController?.navigationBar.tintColor = color
    }
}
