//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddNoteViewController: BaseViewController {
    
    private var noteModal: Notes?
    
    private lazy var presenter = AddNotesPresenter(with: self)
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter your title here."
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private lazy var tagsLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
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
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Description"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter your description here."
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private var shouldUpdate = false
    
    private var tags: [String] = ["Red", "Green", "Blue", "Gray"]
    
    private var selectedTag: String = "Red"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(modal: Notes) {
        super.init(nibName: nil, bundle: nil)
        noteModal = modal
        shouldUpdate = true
        self.initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        initNavigationBar()
        createViews()
    }
}

private extension AddNoteViewController {
    
    func initNavigationBar() {
        navigationItem.title = "Add Title"
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
    }
    
    @objc func doneEditing() {
        guard let data = isValidData() else {
            return
        }
        
        if shouldUpdate {
            presenter.saveNote(id: noteModal!.id!, title: data.title, description: data.description, tags: "")
        } else {
            presenter.addNewNote(title: data.title, description: data.description, tags: selectedTag)
        }
    }
    
    func initData() {
        guard let noteData = noteModal else {
            return
        }
        titleTextField.text = noteData.title
        descriptionTextView.text = noteData.note_description
        shouldUpdate = true
    }
    
    func isValidData() -> (title: String, description: String)? {
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            showAlert(from: self, title: "Error", message: "Title cannot be empty.")
            return nil
        }
        guard let decriptionText = descriptionTextView.text, !decriptionText.isEmpty else {
            showAlert(from: self, title: "Error", message: "Description cannot be empty.")
            return nil
        }
        return (titleText, decriptionText)
    }
    
    func createViews() {
        
        view.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleTextField.topAnchor.constraint(equalTo: safeAreaGuide!.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        titleTextField.delegate = self
        
        view.addSubview(tagsLabel)
        tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tagsLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        
        view.addSubview(tagsPickerView)
        tagsPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tagsPickerView.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        tagsPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tagsPickerView.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: tagsPickerView.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        
        view.addSubview(descriptionTextView)
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 0).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaGuide!.bottomAnchor, constant: 0).isActive = true
        descriptionTextView.delegate = self
    }
}

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter your description here."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
}

extension AddNoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleTextField.textColor == UIColor.lightGray {
            titleTextField.text = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text!.isEmpty {
            titleTextField.text = "Enter your title here."
            titleTextField.textColor = UIColor.lightGray
        }
    }
}

extension AddNoteViewController: AddNotesView {
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddNoteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
}

extension AddNoteViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTag = tags[row]
    }
    
}
