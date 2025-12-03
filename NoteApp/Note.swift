//
//  Note.swift
//  NoteApp
//
//  Created by Ahmed Mac on 3/12/2025.
//

import Foundation

struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
}

// Simple test data so we can see something on the screen immediately
extension Note {
    static let sampleData = [
        Note(title: "Grocery List", content: "Milk, Bread, Eggs", date: Date()),
        Note(title: "App Idea", content: "A note app that tracks github streaks.", date: Date().addingTimeInterval(-86400)),
        Note(title: "Meeting Notes", content: "Discuss project roadmap.", date: Date().addingTimeInterval(-172800))
    ]
}
