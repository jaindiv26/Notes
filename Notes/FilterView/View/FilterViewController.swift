//
//  FilterViewController.swift
//  Notes
//
//  Created by Divyansh Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

struct Filter {
    
    public var tag: Tag?
    public var fromDate: Date?
    public var toDate: Date?
    
}

protocol FilterViewControllerDelegate: class {
    
    func filterViewController(_ filterViewController:FilterViewController,
                              didApplyFilterWith filter: Filter?)
    
}

class FilterViewController: BaseViewController {
    
    private lazy var tagsLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "TAGS"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var tagsContainer: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.cornerRadius
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
       let view = UILabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "DATE"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var dateContainer: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var fromDateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "FROM"
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private lazy var fromDatePicker: UIDatePicker = {
        let view = UIDatePicker.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .date
        return view
    }()
    
    private lazy var toDateLabel: UILabel = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "TO"
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private lazy var toDatePicker: UIDatePicker = {
        let view = UIDatePicker.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .date
        return view
    }()
    
    private lazy var presenter = FilterViewPresenter(with: self)
    private var selectedTag: Tag?
    public weak var delegate: FilterViewControllerDelegate?
    public var appliedFilter: Filter?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        initNavigationBar()
        createViews()
        presenter.getTagsFromDB()
    }
    
    private func initNavigationBar() {
        navigationItem.title = "Filters"
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItems = [cancelBarButtonItem]
        let applyBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(didTapApplyButton))
        let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(didTapClearButton))
        navigationItem.rightBarButtonItems  = [clearBarButtonItem, applyBarButtonItem]
    }
    
    private func createViews() {
        guard let safeAreaGuide = safeAreaGuide else {
            return
        }
        view.addSubview(tagsLabel)
        tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        
        view.addSubview(tagsContainer)
        tagsContainer.leadingAnchor.constraint(equalTo: tagsLabel.leadingAnchor).isActive = true
        tagsContainer.trailingAnchor.constraint(equalTo: tagsLabel.trailingAnchor).isActive = true
        tagsContainer.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        
        tagsContainer.addSubview(tagsPickerView)
        tagsPickerView.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsPickerView.topAnchor.constraint(equalTo: tagsContainer.topAnchor).isActive = true
        tagsPickerView.trailingAnchor.constraint(equalTo: tagsContainer.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        tagsPickerView.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor).isActive = true
        tagsPickerView.heightAnchor.constraint(equalToConstant: UIConstants.pickerHeight).isActive = true
        
        view.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        dateLabel.topAnchor.constraint(equalTo: tagsContainer.bottomAnchor, constant: 2*UIConstants.verticalPadding).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        view.addSubview(dateContainer)
        dateContainer.leadingAnchor.constraint(equalTo: tagsLabel.leadingAnchor).isActive = true
        dateContainer.trailingAnchor.constraint(equalTo: tagsLabel.trailingAnchor).isActive = true
        dateContainer.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        
        dateContainer.addSubview(fromDateLabel)
        fromDateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        fromDateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        fromDateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        
        dateContainer.addSubview(fromDatePicker)
        fromDatePicker.leadingAnchor.constraint(equalTo: fromDateLabel.leadingAnchor).isActive = true
        fromDatePicker.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        fromDatePicker.trailingAnchor.constraint(equalTo: fromDateLabel.trailingAnchor).isActive = true
        fromDatePicker.heightAnchor.constraint(equalToConstant: UIConstants.pickerHeight).isActive = true
        
        dateContainer.addSubview(toDateLabel)
        toDateLabel.leadingAnchor.constraint(equalTo: fromDateLabel.leadingAnchor).isActive = true
        toDateLabel.topAnchor.constraint(equalTo: fromDatePicker.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        toDateLabel.trailingAnchor.constraint(equalTo: fromDateLabel.trailingAnchor).isActive = true
        
        dateContainer.addSubview(toDatePicker)
        toDatePicker.leadingAnchor.constraint(equalTo: fromDateLabel.leadingAnchor).isActive = true
        toDatePicker.topAnchor.constraint(equalTo: toDateLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        toDatePicker.trailingAnchor.constraint(equalTo: fromDateLabel.trailingAnchor).isActive = true
        toDatePicker.heightAnchor.constraint(equalToConstant: UIConstants.pickerHeight).isActive = true
        toDatePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor).isActive = true
    }
    
    func setFilterData() {
        if let tagId = appliedFilter?.tag?.tagID, let index = presenter.getTagIndex(forId: tagId) {
            if index >= 0 && index < tagsPickerView.numberOfRows(inComponent: 0) {
                tagsPickerView.selectRow((index + 1), inComponent: 0, animated: true)
            }
        }
        if let date = appliedFilter?.fromDate {
            fromDatePicker.setDate(date, animated: true)
        }
        if let date = appliedFilter?.toDate {
            toDatePicker.setDate(date, animated: true)
        }
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapApplyButton() {
        let startOfFromDay = Calendar(identifier: .gregorian).startOfDay(for: fromDatePicker.date)
        let startOfToDay = Calendar(identifier: .gregorian).startOfDay(for: toDatePicker.date)
        let endOfToDay = Calendar.current.date(byAdding: .hour, value: 24, to: startOfToDay)
        
        if appliedFilter == nil {
            appliedFilter = Filter.init()
        }
        appliedFilter?.tag = selectedTag
        appliedFilter?.fromDate = startOfFromDay
        appliedFilter?.toDate = endOfToDay
        
        delegate?.filterViewController(self, didApplyFilterWith: appliedFilter)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapClearButton() {
        delegate?.filterViewController(self, didApplyFilterWith: nil)
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: FilterView {
    
    func reloadTagsPickerView() {
        tagsPickerView.reloadAllComponents()
        tagsPickerView.isHidden = false
        setFilterData()
    }
    
    func hideTagsPickerView() {
        tagsPickerView.isHidden = true
    }
}

extension FilterViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "All"
        }
        return presenter.tagsList[row - 1].tag
    }
    
}

extension FilterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1 + presenter.tagsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedTag = nil
        }
        else {
            selectedTag = presenter.tagsList[row - 1]
        }
    }
    
}
