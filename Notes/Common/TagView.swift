//
//  TagView.swift
//  Notes
//
//  Created by Aditya Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import UIKit

class TagView: UIView {
    
    private static let tagInternalSideSpacing: CGFloat = 4
    private static let tagInternalVerticalSpacing: CGFloat = 2
    
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
        tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: TagView.tagInternalSideSpacing).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TagView.tagInternalSideSpacing).isActive = true
        tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: TagView.tagInternalVerticalSpacing).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -TagView.tagInternalVerticalSpacing).isActive = true
    }
    
}
