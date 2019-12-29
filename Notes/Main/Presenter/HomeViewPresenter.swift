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
    private var list: [Notes] = []
    private var filteredList: [Notes] = []
    var managedContext: NSManagedObjectContext?
    
    init(with view: HomeView) {
        self.view = view
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        readNotesFromCoreData()
    }
}

extension HomeViewPresenter {
    
    func readNotesFromCoreData() {
        
        var returnedNotes = [Notes]()
        
        guard let context = managedContext else {
            return
        }
        
        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        notesFetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try context.fetch(notesFetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! Notes
                returnedNotes.append(noteManagedObjectRead)
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }

        list.removeAll()
        filteredList.removeAll()

        let temp = returnedNotes.sorted(by: { (m1, m2) -> Bool in
            m1.date_modified! > m2.date_modified!
        })

        filteredList = temp
        list = temp

        view?.reloadData()
    }
    
    func getCount() -> Int {
        filteredList.count
    }
    
    func getItem(forRow row:Int) -> Notes? {
        if row < 0 || row >= list.count {
            return nil
        }
        return filteredList[row]
    }
    
    func deleteNote(note: Notes, index: Int) {
        guard let context = managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdPredicate = NSPredicate(format: "id = %@", note.id! as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try context.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            context.delete(noteManagedObjectToBeDeleted)
            
            do {
                try context.save()
                list.remove(at: index)
                filteredList.remove(at: index)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    
    func doSearch(forQuery query: String?) {
        var searchQuery = query
        searchQuery = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let searchQuery = searchQuery, searchQuery.count >= Constants.searchMinCharacter {
            let searchedList = list.filter {
                let searchKey = $0.title!.lowercased()
                return searchKey.contains(searchQuery)
            }
            filteredList.removeAll()
            filteredList.append(contentsOf: searchedList)
        }
        else {
            filteredList.removeAll()
            let temp = list.sorted(by: { (m1, m2) -> Bool in
                m1.date_modified! > m2.date_modified!
            })
            filteredList.append(contentsOf: temp)
        }
        view?.reloadData()
    }
}
