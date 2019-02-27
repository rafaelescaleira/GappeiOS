//
//  PageCell.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 10/12/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        
        didSet {
            
            guard let unwrappedPage = page else { return }
            bearImageView.image = UIImage(named: unwrappedPage.imageName)
        }
    }
    
    private let bearImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Telas_apresentacao-1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        
        let topImageContainerView = UIView()
        
        addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        topImageContainerView.addSubview(bearImageView)
        
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .top, relatedBy: .equal, toItem: topImageContainerView, attribute: .top, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .leading, relatedBy: .equal, toItem: topImageContainerView, attribute: .leading, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .trailing, relatedBy: .equal, toItem: topImageContainerView, attribute: .trailing, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .bottom, relatedBy: .equal, toItem: topImageContainerView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
