//
//  FilterViewPresenter.swift
//  Notes
//
//  Created by Divyansh Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol FilterView: class {
    func reloadTagsPickerView()
    func hideTagsPickerView()
}

class FilterViewPresenter {
    
    var view: FilterView?
    var managedContext: NSManagedObjectContext?
    var tagsList: [Tag] = []
    
    init(with view: FilterView) {
        self.view = view
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
}

extension FilterViewPresenter {
    
    func getTagIndex(forId id: UUID) -> Int? {
        for (index, tag) in tagsList.enumerated() {
            if let tagId = tag.tagID, tagId == id {
                return index
            }
        }
        return nil
    }
    
    func getTagsFromDB() {
        tagsList.removeAll()
        
        guard let context = managedContext else {
            return
        }
        
        let tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBTables.tag.rawValue)
        tagsFetchRequest.predicate = nil
        
        do {
            let fetchedTagsFromCoreData = try context.fetch(tagsFetchRequest)
            fetchedTagsFromCoreData.forEach { (fetchRequestResult) in
                if let tagManagedObjectRead = fetchRequestResult as? Tag {
                    tagsList.append(tagManagedObjectRead)
                }
            }
            if (tagsList.count == 0) {
                view?.hideTagsPickerView()
                return
            }
            view?.reloadTagsPickerView()
        } catch {
            print(error)
        }
    }

}

