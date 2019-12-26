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
    
    func addNewNote(note: NoteModal) {
        
        guard let context = managedContext else {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)!
        
        let noteEntity = NSManagedObject(entity: entity, insertInto: context)
        
        noteEntity.setValue(note.noteId, forKey: "id")
        noteEntity.setValue(note.noteTitle, forKey: "title")
        noteEntity.setValue(note.noteDescription, forKey: "note_description")
        noteEntity.setValue(note.dateCreated, forKey: "date_created")
        noteEntity.setValue(note.dateModified, forKey: "date_modified")
        
        do {
            try context.save()
            view?.dismissView()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveNote(note: NoteModal) {
        guard let context = managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdPredicate = NSPredicate(format: "id = %@", note.noteId as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try context.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            noteManagedObjectToBeChanged.setValue(note.noteTitle, forKey: "title")
            noteManagedObjectToBeChanged.setValue(note.noteDescription, forKey: "note_description")
            noteManagedObjectToBeChanged.setValue(Date(), forKey: "date_modified")
            try context.save()
            view?.dismissView()
        } catch let error as NSError {

            print("Could not change. \(error), \(error.userInfo)")
        }
    }
}
