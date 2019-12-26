//
//  NoteModal.swift
//  Notes
//
//  Created by Divyansh Jain on 25/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation

struct NoteModal {
    
    private(set) var noteId: UUID
    private(set) var noteTitle: String
    private(set) var noteDescription: String
    private(set) var dateCreated: Date
    private(set) var dateModified: Date
    
    init(noteTitle:String, noteDescription:String) {
        self.noteId = UUID()
        self.noteTitle = noteTitle
        self.noteDescription = noteDescription
        self.dateCreated = Date()
        self.dateModified = Date()
    }

    init(noteId: UUID, noteTitle: String, noteDescription: String, dateCreated: Date, dateModified: Date) {
        self.noteId = noteId
        self.noteTitle = noteTitle
        self.noteDescription = noteDescription
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}
