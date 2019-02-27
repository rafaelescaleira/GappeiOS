//
//  TelaInicialPageViewController.swift
//  Gappe
//
//  Created by Catwork on 28/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class TelaInicialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "Tela1"),
                self.newVC(viewController: "Tela2"),
                self.newVC(viewController: "Tela3"),
                self.newVC(viewController: "Tela4")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: 80))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            //return orderedViewControllers.first
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    

}






