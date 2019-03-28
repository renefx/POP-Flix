//
//  UIViewControllerExtension.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import ARSLineProgress

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
    
    func createLoading(uiView: UIView, frame: CGRect, color: UIColor = Color.blueShadow) -> UIView? {
        let window = UIApplication.shared.keyWindow!
        
        let container = UIView(frame: frame)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        ARSLineProgress.show()
        
        window.addSubview(container);
        return container
    }
    
    func removeLoading(uiView: UIView?) {
        ARSLineProgress.hide()
        uiView?.removeFromSuperview()
    }
}
