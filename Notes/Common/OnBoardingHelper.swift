//
//  OnBoardingHelper.swift
//  Notes
//
//  Created by Divyansh Jain on 30/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import CoreData
import UIKit

class OnBoardingHelper {
    
    private var managedContext: NSManagedObjectContext?
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    func addOnBoardingData() {
        //Tag
        guard let context = managedContext,
            let tagEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.DBTables.tag.rawValue,
                                                                into: context) as? Tag else {
            return
        }
        tagEntity.tag = "Welcome"
        tagEntity.tagID = UUID()
        tagEntity.colorHex = UIColor.random.toHex
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        //Note 1
        guard let notesEntity1 = NSEntityDescription.insertNewObject(forEntityName: Constants.DBTables.notes.rawValue,
                                                                     into: context) as? Notes else {
            return
        }
        notesEntity1.id = UUID()
        notesEntity1.title = "Hello, and welcome to Notes"
        notesEntity1.noteDescription = "Notes is a beautiful, yet powerful app for your notes, ideas, prose, novels, and everything in between. Whether you're a casual note-taker, or a full-fledged author, you can pick the app up and get started immediately, just like with this note here.\n\nYou're currently in the note editor, which is purposefully designed to be minimal, allowing you to focus on the content that matters - your words."
        notesEntity1.dateCreated = Date()
        notesEntity1.tag = tagEntity
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        //Note 2
        guard let notesEntity2 = NSEntityDescription.insertNewObject(forEntityName: Constants.DBTables.notes.rawValue,
                                                                     into: context) as? Notes else {
            return
        }
        notesEntity2.id = UUID()
        notesEntity2.title = "Swipe me right"
        notesEntity2.noteDescription = "Swipe me right to present some options"
        notesEntity2.dateCreated = Date()
        notesEntity2.tag = tagEntity
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
