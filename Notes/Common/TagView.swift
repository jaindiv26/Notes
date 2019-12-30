//
//  TagView.swift
//  Notes
//
//  Created by Aditya Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import UIKit

class TagView: UIView {
    
    struct Constants {
        
        static let tagInternalSideSpacing: CGFloat = 4
        static let tagInternalVerticalSpacing: CGFloat = 2
        public static let defaultBgColor: UIColor = UIColor.black
        
    }
    
    public lazy var tagLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.numberOfLines = 1
        view.textColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        clipsToBounds = true
        layer.cornerRadius = UIConstants.cornerRadius/2
        
        addSubview(tagLabel)
        tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.tagInternalSideSpacing).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tagInternalSideSpacing).isActive = true
        tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tagInternalVerticalSpacing).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.tagInternalVerticalSpacing).isActive = true
    }
    
}
