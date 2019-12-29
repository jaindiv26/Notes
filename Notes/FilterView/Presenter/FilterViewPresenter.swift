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
    var tagsList: [String] = []
    
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
    
    func getTagsFromDB() {
        tagsList.removeAll()
        
        guard let context = managedContext else {
            return
        }
        
        let tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        tagsFetchRequest.predicate = nil
        
        do {
            let fetchedTagsFromCoreData = try context.fetch(tagsFetchRequest)
            fetchedTagsFromCoreData.forEach { (fetchRequestResult) in
                let tagManagedObjectRead = fetchRequestResult as! Tag
                let item = tagManagedObjectRead.value(forKey: "tag") as! String
                tagsList.append(item)
            }
            if (tagsList.count == 0) {
                view?.hideTagsPickerView()
                return
            }
            view?.reloadTagsPickerView()
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
        }
    }

}

