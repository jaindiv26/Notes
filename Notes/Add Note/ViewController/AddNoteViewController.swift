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

protocol AddNoteViewControllerDelegate: class {
    
    func addNoteViewController(_ addNoteViewController: AddNoteViewController, didAddNote note: Notes)
    
    func addNoteViewController(_ addNoteViewController: AddNoteViewController, didUpdateNote note: Notes)
    
}

final class AddNoteViewController: BaseViewController {
        
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "TITLE"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var titleContainer: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.systemBackground
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
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
    
    private lazy var addTagsButton: UIButton = {
        let view = UIButton(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "plus"), for: .normal)
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
        view.text = "DESCRIPTION"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var descriptionContainer: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.systemBackground
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.backgroundColor = .clear
        view.textContainerInset = UIEdgeInsets.zero
        return view
    }()
    
    private var selectedTag: Tag?
    private var noteModal: Notes?
    public weak var delegate: AddNoteViewControllerDelegate?
    private lazy var presenter = AddNotesPresenter(withDelegate: self)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(modal: Notes) {
        super.init(nibName: nil, bundle: nil)
        noteModal = modal
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
        presenter.getTags()
    }
}

private extension AddNoteViewController {
    
    func initNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let doneBarButtonItem = UIBarButtonItem(title: "Done",
                                                style: .done,
                                                target: self, action: #selector(doneEditingNote))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
    }
    
    @objc func doneEditingNote() {
        guard let data = isValidData() else {
            return
        }
        if let note = noteModal, let noteId = note.id {
            presenter.updateNote(forId: noteId,
                                 title: data.title,
                                 description: data.description,
                                 tag: selectedTag)
        } else {
            presenter.addNewNote(title: data.title,
                                 description: data.description,
                                 tag: selectedTag)
        }
    }
    
    func initData() {
        guard let noteData = noteModal else {
            return
        }
        titleTextField.text = noteData.title
        descriptionTextView.text = noteData.noteDescription
    }
    
    func isValidData() -> (title: String, description: String)? {
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            showAlert(from: self, title: "Error", message: "Title cannot be empty.")
            return nil
        }
        guard let descriptionText = descriptionTextView.text, !descriptionText.isEmpty else {
            showAlert(from: self, title: "Error", message: "Description cannot be empty.")
            return nil
        }
        return (titleText, descriptionText)
    }
    
    func createViews() {
        guard let safeAreaGuide = safeAreaGuide else {
            return
        }
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 2*UIConstants.verticalPadding).isActive = true
        
        view.addSubview(titleContainer)
        titleContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        titleContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        titleContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        
        titleContainer.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        titleTextField.delegate = self
        
        view.addSubview(tagsLabel)
        tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 2*UIConstants.verticalPadding).isActive = true
        
        view.addSubview(addTagsButton)
        addTagsButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        addTagsButton.centerYAnchor.constraint(equalTo: tagsLabel.centerYAnchor).isActive = true
        addTagsButton.addTarget(self, action: #selector(didTapAddTagsButton), for: .touchUpInside)
        
        tagsLabel.trailingAnchor.constraint(equalTo: addTagsButton.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        
        view.addSubview(tagsContainer)
        tagsContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        tagsContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        tagsContainer.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        
        tagsContainer.addSubview(tagsPickerView)
        tagsPickerView.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        tagsPickerView.topAnchor.constraint(equalTo: tagsContainer.topAnchor).isActive = true
        tagsPickerView.trailingAnchor.constraint(equalTo: tagsContainer.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        tagsPickerView.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor).isActive = true
        tagsPickerView.heightAnchor.constraint(equalToConstant: UIConstants.pickerHeight).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: tagsContainer.bottomAnchor, constant: 2*UIConstants.verticalPadding).isActive = true
        
        view.addSubview(descriptionContainer)
        descriptionContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: UIConstants.betweenPadding).isActive = true
        descriptionContainer.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        
        descriptionContainer.addSubview(descriptionTextView)
        descriptionTextView.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor, constant: UIConstants.sidePadding).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionContainer.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor, constant: -UIConstants.verticalPadding).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor, constant: -UIConstants.sidePadding).isActive = true
        descriptionTextView.delegate = self
    }
    
    @objc func didTapAddTagsButton() {
        let alertController = UIAlertController(title: "Add Tag", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            guard let textField = alertController.textFields?[0] else {
                return
            }
            if let text = textField.text, !text.isEmpty {
                self.presenter.didAddTag(tag: text)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField) -> Void in
            textField.placeholder = "Tag name"
        })
        present(alertController, animated: true, completion: nil)
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
        if let text = titleTextField.text, text.isEmpty {
            titleTextField.text = "Enter your title here."
            titleTextField.textColor = UIColor.lightGray
        }
    }
}

extension AddNoteViewController: AddNotesPresenterDelegate {
    
    func didAddNote(note: Notes) {
        delegate?.addNoteViewController(self, didAddNote: note)
        navigationController?.popViewController(animated: true)
    }
    
    func didUpdateNote(note: Notes) {
        delegate?.addNoteViewController(self, didUpdateNote: note)
        navigationController?.popViewController(animated: true)
    }
    
    func didAddTag(atIndex index: Int) {
        tagsPickerView.isHidden = false
        tagsPickerView.reloadAllComponents()
        tagsPickerView.selectRow((index + 1), inComponent: 0, animated: true)
        selectedTag = presenter.tagsList[index]
    }
    
    func didFetchTags() {
        tagsPickerView.reloadAllComponents()
        tagsPickerView.isHidden = false
    }
    
    func hideTagsPickerView() {
        tagsPickerView.isHidden = true
    }
}

extension AddNoteViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Select tag"
        }
        else {
            return presenter.tagsList[row - 1].tag
        }
    }
    
}

extension AddNoteViewController: UIPickerViewDataSource {
    
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
