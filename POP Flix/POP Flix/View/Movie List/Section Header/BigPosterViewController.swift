//
//  BigPosterViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors

protocol BigPosterViewControllerDelegate: AnyObject {
    func didSelectMovie()
}

class BigPosterViewController: UIViewController {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var imageData: Data?
    var movieName: String?
    var delegate: BigPosterViewControllerDelegate?
    var isLoading: Bool = false
    var colorPrimary: UIColor?
    var colorDetail: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = movieName
        if let data = imageData, let headerImage = UIImage(data: data) {
            poster.image = headerImage
            if let colors = headerImage.getColors() {
                
                let gradientMaskLayer:CAGradientLayer = CAGradientLayer()
                let frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: gradient.frame.height)
                gradientMaskLayer.frame = frame
                gradientMaskLayer.colors = [UIColor.clear.cgColor, colors.secondary.cgColor]
                gradientMaskLayer.locations = [0.0, 0.4]
                gradient.layer.mask = gradientMaskLayer
                gradient.backgroundColor = colors.primary.withAlphaComponent(0.80)
                colorPrimary = colors.primary
                let colorForTexts = colors.background
                movieTitle.textColor = colorForTexts
                colorDetail = colorForTexts
            }
        }
    }
    
    @IBAction func selectedMovie(_ sender: Any) {
        if isLoading { return }
        delegate?.didSelectMovie()
    }
}
