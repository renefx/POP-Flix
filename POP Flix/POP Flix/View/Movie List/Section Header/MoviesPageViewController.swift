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
}

class MoviesPageViewController: UIPageViewController {
    private var pages: [UIViewController] = []
    private var timer = Timer()
    
    weak var delegateMovie: MoviesPageViewControllerDelegate?
    var movies: [(String, String)] = [] {
        didSet {
            pages = movies.map({ (movie) -> UIViewController in
                let vc = createViewController()
                if let vc = vc as? BigPosterViewController {
                    vc.delegate = self
                    vc.imageName = movie.0
                    vc.movieName = movie.1
                }
                return vc
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .red
        appearance.currentPageIndicatorTintColor = .green
        
        self.dataSource = self
        if let firstViewController = pages.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    @objc func updateTimer() {
        let index = (getCurrentIndex() + 1) % pages.count
        let viewController = pages[index]
        setViewControllers([viewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func getCurrentIndex() -> Int {
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
