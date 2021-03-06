//
//  MoviesPageViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

protocol MoviesPageViewControllerDelegate: AnyObject {
    func selectedMovie(_ index: Int)
    func changedColor(_ color: UIColor, _ detail: UIColor)
}

class MoviesPageViewController: UIPageViewController {
    private var pages: [UIViewController] = []
    private var timer = Timer()
    private var lastIndex = -1
    var frameLoading: CGRect = CGRect(origin: .zero, size: .zero)
    var loading: UIActivityIndicatorView?
    
    weak var delegateMovie: MoviesPageViewControllerDelegate?
    
    var movies: [(Data?, String?)] = [] {
        didSet {
            pages = movies.map({ (movie) -> UIViewController in
                let vc = createViewController()
                if let vc = vc as? BigPosterViewController {
                    vc.delegate = self
                    vc.imageData = movie.0
                    vc.movieName = movie.1
                }
                return vc
            })
            
            if pages.count > getCurrentIndex() {
                setViewController(atIndex: getCurrentIndex())
                lastIndex = -1
            }
            
            if movies.count > 0 {
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 8, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.dataSource = self
        self.delegate = self
    }
    
    @objc func updateTimer() {
        let index = (getCurrentIndex() + 1) % pages.count
        setViewController(atIndex: index)
    }
    
    func setViewController(atIndex index: Int) {
        let viewController = pages[index]
        setViewControllers([viewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        
        if let viewController = viewController as? BigPosterViewController,
            let color = viewController.colorPrimary,
            let detail = viewController.colorDetail {
            delegateMovie?.changedColor(color, detail)
        }
    }
    
    func stopScroll() {
        timer.invalidate()
        lastIndex = getCurrentIndex()
    }
    
    func getCurrentIndex() -> Int {
        if lastIndex > 0 { return lastIndex }
        guard let first = viewControllers?.first,
            let firstViewControllerIndex = pages.index(of: first) else {
                return 0
        }

        return firstViewControllerIndex
    }
    
    func createViewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.bigPoster)
    }
}

extension MoviesPageViewController: BigPosterViewControllerDelegate {
    func didSelectMovie() {
        delegateMovie?.selectedMovie(getCurrentIndex())
    }
}

extension MoviesPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let bigPosterVC = pageViewController.viewControllers?.first as? BigPosterViewController,
            let colorPrimary = bigPosterVC.colorPrimary,
            let colorDetail = bigPosterVC.colorDetail {
            delegateMovie?.changedColor(colorPrimary, colorDetail)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = (viewControllerIndex + 1) % pages.count
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
}
