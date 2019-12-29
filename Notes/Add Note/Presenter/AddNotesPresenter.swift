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

protocol AddNotesView: class {
    func dismissView()
}

class AddNotesPresenter {
    
    weak var view: AddNotesView?
    
    var managedContext: NSManagedObjectContext?
    
    init(with view: AddNotesView) {
        self.view = view
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
}

extension AddNotesPresenter {
    
    func addNewNote(title: String, description: String, tags: String) {
        
        guard let context = managedContext else {
            return
        }
        
        let tagEntity = NSEntityDescription.entity(forEntityName: "Tag", in: context)!
        let newTagsEntity = NSManagedObject(entity: tagEntity, insertInto: context)
        
        newTagsEntity.setValue(UUID(), forKey: "tagID")
        newTagsEntity.setValue(tags, forKey: "tag")
        
        let notesEntity = NSEntityDescription.entity(forEntityName: "Notes", in: context)!
        let newNoteEntity = NSManagedObject(entity: notesEntity, insertInto: context)
        
        newNoteEntity.setValue(UUID(), forKey: "id")
        newNoteEntity.setValue(title, forKey: "title")
        newNoteEntity.setValue(description, forKey: "note_description")
        newNoteEntity.setValue(Date(), forKey: "date_created")
        newNoteEntity.setValue(Date(), forKey: "date_modified")
        newNoteEntity.setValue(newTagsEntity, forKey: "tag")
        
        do {
            try context.save()
            view?.dismissView()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveNote(id: UUID, title: String, description: String, tags: String) {
        guard let context = managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdPredicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try context.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            noteManagedObjectToBeChanged.setValue(title, forKey: "title")
            noteManagedObjectToBeChanged.setValue(description, forKey: "note_description")
            noteManagedObjectToBeChanged.setValue(Date(), forKey: "date_modified")
            noteManagedObjectToBeChanged.setValue(tags, forKey: "tag")
            try context.save()
            view?.dismissView()
        } catch let error as NSError {

            print("Could not change. \(error), \(error.userInfo)")
        }
    }
}
