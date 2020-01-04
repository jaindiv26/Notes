//
//  AddNotesPresenter.swift
//  Notes
//
//  Created by Divyansh Jain on 26/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol AddNotesPresenterDelegate: class {
    
    func didAddNote(note: Notes)
    
    func didUpdateNote(note: Notes)
    
    func didAddTag(atIndex index: Int)
    
    func didFetchTags()
    
    func hideTagsPickerView()
    
    func showErrorMessage(_ errorMessage: String?)
    
}

class AddNotesPresenter {
    
    private weak var delegate: AddNotesPresenterDelegate?
    private var managedContext: NSManagedObjectContext?
    var tagsList: [Tag] = []
    
    init(withDelegate delegate: AddNotesPresenterDelegate) {
        self.delegate = delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        }
    }
    
}

extension AddNotesPresenter {
    
    func getTags() {
        tagsList.removeAll()
        guard let context = managedContext else {
            delegate?.hideTagsPickerView()
            return
        }
        tagsList.append(contentsOf: getTagsFromDB(managedContext: context))
        if tagsList.isEmpty {
            delegate?.hideTagsPickerView()
            return
        }
        delegate?.didFetchTags()
    }
    
    func didAddTag(tag: String) {
        guard let context = managedContext,
            let tagEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.DBTables.tag.rawValue,
                                                                into: context) as? Tag else {
            delegate?.showErrorMessage(nil)
            return
        }
        tagEntity.tag = tag
        tagEntity.tagID = UUID()
        tagEntity.colorHex = UIColor.random.toHex
        do {
            try context.save()
            tagsList.append(tagEntity)
            delegate?.didAddTag(atIndex: tagsList.count - 1)
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
            print(error)
        }
    }
    
    func addNewNote(title: String, description: String, tag: Tag?) {
        guard let context = managedContext,
            let notesEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.DBTables.notes.rawValue,
                                                                  into: context) as? Notes else {
            delegate?.showErrorMessage(nil)
            return
        }
        notesEntity.id = UUID()
        notesEntity.title = title
        notesEntity.noteDescription = description
        notesEntity.dateCreated = Date()
        notesEntity.tag = tag
        do {
            try context.save()
            delegate?.didAddNote(note: notesEntity)
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
            print(error)
        }
    }
    
    func updateNote(forId id: UUID, title: String, description: String, tag: Tag?) {
        guard let context = managedContext else {
            delegate?.showErrorMessage(nil)
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBTables.notes.rawValue)
        let noteIdPredicate = NSPredicate(format: "id = %@", id as CVarArg)
        fetchRequest.predicate = noteIdPredicate
        do {
            let fetchedNotesFromCoreData = try context.fetch(fetchRequest)
            guard let notesEntity = fetchedNotesFromCoreData[0] as? Notes else {
                delegate?.showErrorMessage(nil)
                return
            }
            notesEntity.title = title
            notesEntity.noteDescription = description
            notesEntity.dateModified = Date()
            notesEntity.tag = tag
            try context.save()
            delegate?.didUpdateNote(note: notesEntity)
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
            print(error)
        }
    }
    
    func getTagIndex(forId id: UUID) -> Int? {
        for (index, tag) in tagsList.enumerated() {
            if let tagId = tag.tagID, tagId == id {
                return index
            }
        }
        return nil
    }
}

private extension AddNotesPresenter {
    
    func getTagsFromDB(managedContext: NSManagedObjectContext) -> [Tag] {
        var tagsList: [Tag] = []
        let tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBTables.tag.rawValue)
        tagsFetchRequest.predicate = nil
        do {
            let fetchedTagsFromCoreData = try managedContext.fetch(tagsFetchRequest)
            fetchedTagsFromCoreData.forEach { (fetchRequestResult) in
                if let tag = fetchRequestResult as? Tag {
                    tagsList.append(tag)
                }
            }
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
            print(error)
        }
        return tagsList
    }
    
}
