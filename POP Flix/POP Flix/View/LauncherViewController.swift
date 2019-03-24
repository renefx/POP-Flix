//
//  LauncherViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class LauncherViewController: UIViewController {
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appIcon.popOut { (returnAnimation) in
            self.removeFromParent()
            let storyboard = UIStoryboard(name: StoryboardID.storyboardName, bundle: nil)
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.present(initialViewController, animated: false, completion: nil)
            }
        }
    }

}
