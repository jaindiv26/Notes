//
//  HomeViewPresenter.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol HomeView: class {
    func reloadData()
}

class HomeViewPresenter {
    
    weak var view: HomeView?
    
    private var notesCount = 0
    private var notesList: [NoteModal] = []
    
    init(with view: HomeView) {
        self.view = view
        readNotesFromCoreData()
    }
    
}

extension HomeViewPresenter {
    
    func readNotesFromCoreData() {
        
        var returnedNotes = [NoteModal]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try managedContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedNotes.append(NoteModal.init(
                    noteId: noteManagedObjectRead.value(forKey: "id") as! UUID,
                    noteTitle: noteManagedObjectRead.value(forKey: "title") as! String,
                    noteDescription: noteManagedObjectRead.value(forKey: "note_description") as! String,
                    dateCreated: noteManagedObjectRead.value(forKey: "date_created")  as! Date,
                    dateModified: noteManagedObjectRead.value(forKey: "date_modified") as! Date))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        notesList.removeAll()
        notesList = returnedNotes
        view?.reloadData()
    }
    
    func getCount() -> Int {
        notesList.count
    }
    
    func getItem(forRow row:Int) -> NoteModal? {
        if row < 0 || row >= notesList.count {
            return nil
        }
        return notesList[row]
    }
}
