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
    
    private lazy var containerView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.numberOfLines = 1
        view.textColor = UIColor.systemGray2
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.numberOfLines = 2
        view.textColor = UIColor.systemGray
        return view
    }()
    
    private lazy var tagView: TagView = {
        let view = TagView.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    private func createViews() {
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.verticalPadding/2).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.verticalPadding/2).isActive = true
        
        containerView.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        containerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -UIConstants.sidePadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.betweenPadding/2).isActive = true
        
        containerView.addSubview(tagView)
        tagView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        tagView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        tagView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
    }
    
    func setData(modal: Notes) {
        titleLabel.text = modal.title
        descriptionLabel.text = modal.noteDescription
        if let dateCreated = modal.dateCreated {
            dateLabel.text = getNoteDisplayDate(date: dateCreated)
        }
        if let tagText = modal.tag?.tag, !tagText.isEmpty {
            tagView.tagLabel.text = tagText
            tagView.isHidden = false
        }
        else {
            tagView.tagLabel.text = nil
            tagView.isHidden = true
        }
        if let colorHex = modal.tag?.colorHex, !colorHex.isEmpty {
            tagView.backgroundColor = UIColor.init(hex: colorHex)
        }
        else {
            tagView.backgroundColor = TagView.Constants.defaultBgColor
        }
    }
    
    private func getNoteDisplayDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
