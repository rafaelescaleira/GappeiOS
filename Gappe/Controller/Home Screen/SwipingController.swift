//
//  SwipingController.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 10/12/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class SwipingController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let pages = [
        Page(imageName: "Telas_apresentacao-1"),
        Page(imageName: "Telas_apresentacao-2"),
        Page(imageName: "Telas_apresentacao-3"),
        Page(imageName: "Telas_apresentacao-4")
    ]
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Login", sender: nil)
    }
    @IBAction func handlePrev() {
        
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func handleNext() {
        
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.isPagingEnabled = true
    }
    
}
