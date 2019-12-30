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

protocol HomeViewPresenterDelegate: class {
    
    func didLoadNotes()
    
    func didDeleteNote(atIndex index: Int)
    
    func showErrorMessage(_ errorMessage: String?)
    
}

class HomeViewPresenter {
    
    private weak var delegate: HomeViewPresenterDelegate?
    private var list: [Notes] = []
    private var filteredList: [Notes] = []
    private var managedContext: NSManagedObjectContext?
    var appliedFilter: Filter?
    
    init(withDelegate delegate: HomeViewPresenterDelegate) {
        self.delegate = delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    func getData() {
        getNotesFromCoreData()
    }
    
    func getNumberOfItems() -> Int {
        filteredList.count
    }
    
    func getItem(forRow row: Int) -> Notes? {
        if row < 0 || row >= list.count {
            return nil
        }
        return filteredList[row]
    }
    
    func deleteNote(note: Notes, index: Int) {
        guard let context = managedContext, let noteId = note.id as CVarArg? else {
            delegate?.showErrorMessage(nil)
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let noteIdPredicate = NSPredicate(format: "id = %@", noteId)
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try context.fetch(fetchRequest)
            guard let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as? NSManagedObject else {
                delegate?.showErrorMessage(nil)
                return
            }
            context.delete(noteManagedObjectToBeDeleted)
            try context.save()
            list.remove(at: index)
            filteredList.remove(at: index)
            delegate?.didDeleteNote(atIndex: index)
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
            print(error)
        }
    }
    
    func doSearch(forQuery query: String?) {
        var searchQuery = query
        searchQuery = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let searchQuery = searchQuery, searchQuery.count >= Constants.searchMinCharacter {
            let searchedList = list.filter {
                var searchKey = ""
                if let title = $0.title {
                    searchKey += title.lowercased()
                }
                if let description = $0.noteDescription {
                    searchKey += description.lowercased()
                }
                return searchKey.contains(searchQuery)
            }
            filteredList.removeAll()
            filteredList.append(contentsOf: searchedList)
        }
        else {
            filteredList.removeAll()
            let sortedNotes = sortNotes(list)
            filteredList.append(contentsOf: sortedNotes)
        }
        delegate?.didLoadNotes()
    }
    
    func filterNotes(withAppliedFilter filter: Filter?) {
        self.appliedFilter = filter
        filteredList.removeAll()
        let sortedNotes = sortNotes(list)
        filteredList.append(contentsOf: sortedNotes)
        if let tagId = filter?.tag?.tagID {
            let filteredTagNotes = filteredList.filter { (note) -> Bool in
                if let noteTagId = note.tag?.tagID, noteTagId == tagId {
                    return true
                }
                return false
            }
            filteredList.removeAll()
            let sortedNotes = sortNotes(filteredTagNotes)
            filteredList.append(contentsOf: sortedNotes)
        }
        if let fromDate = filter?.fromDate {
            let filteredFromDateNotes = filteredList.filter { (note) -> Bool in
                if let noteCreatedDate = note.dateCreated, noteCreatedDate >= fromDate {
                    return true
                }
                return false
            }
            filteredList.removeAll()
            let sortedNotes = sortNotes(filteredFromDateNotes)
            filteredList.append(contentsOf: sortedNotes)
        }
        if let toDate = filter?.toDate {
            let filteredToDateNotes = filteredList.filter { (note) -> Bool in
                if let noteCreatedDate = note.dateCreated, noteCreatedDate <= toDate {
                    return true
                }
                return false
            }
            filteredList.removeAll()
            let sortedNotes = sortNotes(filteredToDateNotes)
            filteredList.append(contentsOf: sortedNotes)
        }
        delegate?.didLoadNotes()
    }
    
}

private extension HomeViewPresenter {
    
    func getNotesFromCoreData() {
        list.removeAll()
        filteredList.removeAll()
        
        var returnedNotes = [Notes]()
        guard let context = managedContext else {
            delegate?.showErrorMessage(nil)
            return
        }
        
        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBTables.notes.rawValue)
        notesFetchRequest.predicate = nil
        do {
            let fetchedNotesFromCoreData = try context.fetch(notesFetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                if let noteManagedObjectRead = fetchRequestResult as? Notes {
                    returnedNotes.append(noteManagedObjectRead)
                }
            }
        } catch {
            print(error)
            delegate?.showErrorMessage(error.localizedDescription)
        }
        let sortedNotes = sortNotes(returnedNotes)
        filteredList.append(contentsOf: sortedNotes)
        list.append(contentsOf: sortedNotes)
        delegate?.didLoadNotes()
    }
    
    func sortNotes(_ notes: [Notes]) -> [Notes]{
        return notes.sorted(by: { (m1, m2) -> Bool in
            if let m1Date = m1.dateModified, let m2Date = m2.dateModified {
                return m1Date > m2Date
            }
            return false
        })
    }
}
