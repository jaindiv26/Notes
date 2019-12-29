//
//  FilterViewController.swift
//  Notes
//
//  Created by Divyansh Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

class FilterViewController: BaseViewController {
    
    private lazy var tagsLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Tags"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private lazy var tagsPickerView: UIPickerView = {
        let view = UIPickerView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Date"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private lazy var fromDateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "From"
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private lazy var fromDatePicker: UIDatePicker = {
        let view = UIDatePicker.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .dateAndTime
        return view
    }()
    
    private lazy var toDateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "To"
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private lazy var toDatePicker: UIDatePicker = {
        let view = UIDatePicker.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .dateAndTime
        return view
    }()
    
    init(delegate: FilterViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var presenter = FilterViewPresenter(with: self)
    private var selectedTag = ""
    private var delegate: FilterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        initNavigationBar()
        createViews()
        presenter.getTagsFromDB()
    }
    
    private func initNavigationBar() {
        navigationItem.title = "Apply filter"
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
    }
    
    private func createViews() {
        
        guard let safeAreaGuide = safeAreaGuide else {
            return
        }
        
        view.addSubview(tagsLabel)
        tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        
        view.addSubview(tagsPickerView)
        tagsPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsPickerView.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        tagsPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        tagsPickerView.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        
        view.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        dateLabel.topAnchor.constraint(equalTo: tagsPickerView.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        view.addSubview(fromDateLabel)
        fromDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        fromDateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        fromDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        view.addSubview(fromDatePicker)
        fromDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        fromDatePicker.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        fromDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        view.addSubview(toDateLabel)
        toDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        toDateLabel.topAnchor.constraint(equalTo: fromDatePicker.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        toDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        view.addSubview(toDatePicker)
        toDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        toDatePicker.topAnchor.constraint(equalTo: toDateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        toDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        toDatePicker.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
    }
    
    @objc func didTapDoneButton() {
        delegate?.applyFilter(tags: selectedTag, fromDate: fromDatePicker.date, toDate: toDatePicker.date)
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: FilterView {
    
    func reloadTagsPickerView() {
        tagsPickerView.reloadAllComponents()
        tagsPickerView.isHidden = false
    }
    
    func hideTagsPickerView() {
        tagsPickerView.isHidden = true
    }
}

extension FilterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.tagsList[row]
    }
}

extension FilterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.tagsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTag = presenter.tagsList[row]
    }
    
}
