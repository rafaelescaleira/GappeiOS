//
//  ApresentacaoCollectionViewCell.swift
//  Gappe
//
//  Created by Rafael Escaleira on 01/03/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit

class ApresentacaoCollectionViewCell: UICollectionViewCell {
    
    var apresentacao: Apresentacao? {
        
        didSet {
            
            guard let unwrappedPage = apresentacao else { return }
            bearImageView.image = UIImage(named: unwrappedPage.imageName)
            
            let attributedText = NSMutableAttributedString(string: unwrappedPage.title, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 20)!])
            
            attributedText.append(NSAttributedString(string: "\n\n\(unwrappedPage.textPresentation)", attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.black]))
            
            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .left
        }
    }
    
    private let bearImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Apresentacao0"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        
        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        textView.backgroundColor = .clear
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        
        let topImageContainerView = UIView()
        
        addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 40))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: topImageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (self.bounds.width * 0.563)))
        
        topImageContainerView.addSubview(bearImageView)
        
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .top, relatedBy: .equal, toItem: topImageContainerView, attribute: .top, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .leading, relatedBy: .equal, toItem: topImageContainerView, attribute: .leading, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .trailing, relatedBy: .equal, toItem: topImageContainerView, attribute: .trailing, multiplier: 1, constant: 0))
        topImageContainerView.addConstraint(NSLayoutConstraint(item: bearImageView, attribute: .bottom, relatedBy: .equal, toItem: topImageContainerView, attribute: .bottom, multiplier: 1, constant: 0))
        
        addSubview(descriptionTextView)
        
        addConstraint(NSLayoutConstraint(item: descriptionTextView, attribute: .top, relatedBy: .equal, toItem: topImageContainerView, attribute: .bottom, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: descriptionTextView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: descriptionTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15))
        addConstraint(NSLayoutConstraint(item: descriptionTextView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -85))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
