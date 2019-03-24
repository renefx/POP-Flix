//
//  UIViewExtension.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

extension UIView {
    func popUp(_ completion: ((Bool) -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: completion)
    }
    
    func popOut(_ completion: ((Bool) -> Void)? = nil) {
        let identity: ((Bool) -> Void)? = { (bool) in
            self.animateIdentity(completion)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: identity)
    }
    
    func animateIdentity(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: completion)
    }
}
