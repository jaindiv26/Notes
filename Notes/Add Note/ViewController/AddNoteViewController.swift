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
    
    private var noteModal: NoteModal?
    
    private lazy var presenter = AddNotesPresenter(with: self)
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter your title here."
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(modal: NoteModal) {
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
            presenter.saveNote(note: NoteModal(
                noteId: noteModal!.noteId,
                noteTitle: data.title,
                noteDescription: data.description,
                dateCreated: noteModal!.dateCreated,
                dateModified: Date())
            )
        } else {
            presenter.addNewNote(note: NoteModal(noteTitle: data.title, noteDescription: data.description))
        }
    }
    
    func initData() {
        guard let noteData = noteModal else {
            return
        }
        titleTextField.text = noteData.noteTitle
        descriptionTextView.text = noteData.noteDescription
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
        
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
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
