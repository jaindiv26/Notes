//
//  HomeViewCell.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

class HomeViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private let cellSeperator = UIView.init(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    private func createViews() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        
        cellSeperator.backgroundColor = .systemGray2
        cellSeperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellSeperator)
        cellSeperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: UIConstants.sidePadding).isActive = true
        cellSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -UIConstants.sidePadding).isActive = true
        cellSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellSeperator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                           constant: UIConstants.verticalPadding).isActive = true
        cellSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func setData(modal: NoteModal) {
        titleLabel.text = modal.noteTitle
        descriptionLabel.text = modal.noteDescription
    }
    
}
