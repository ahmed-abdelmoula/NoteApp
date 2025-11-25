//
//  ContentView.swift
//  NoteApp
//
//  Created by Ahmed Mac on 24/11/2025.
//

import SwiftUI

@main
struct SmartNoteApp: App {
    @StateObject private var store = NoteStore()

    var body: some Scene {
        WindowGroup {
            MainInterface()
                .environmentObject(store)
        }
    }
}

// MARK: - Main Interface

struct MainInterface: View {
    @EnvironmentObject var store: NoteStore
    @State private var searchText: String = ""
    @State private var selectedTag: String? = nil
    @State private var showingNewNote = false

    var filteredNotes: [Note] {
        var list = store.notes
        if let tag = selectedTag {
            list = list.filter { $0.tags.contains(tag) }
        }
        if !searchText.isEmpty {
            let lowerSearch = searchText.lowercased()
            list = list.filter { $0.title.lowercased().contains(lowerSearch) || $0.body.lowercased().contains(lowerSearch) || $0.tags.joined(separator: " ").contains(lowerSearch) }
        }
        list.sort { a, b in
            if a.pinned != b.pinned { return a.pinned && !b.pinned }
            return a.updatedAt > b.updatedAt
        }
        return list
    }

    var body: some View {
        NavigationView {
            List {
                if !uniqueTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            TagChip(tag: "All", isSelected: selectedTag == nil) { selectedTag = nil }
                            ForEach(uniqueTags, id: \.(self)) { tag in
                                TagChip(tag: tag, isSelected: selectedTag == tag) {
                                    selectedTag = (selectedTag == tag ? nil : tag)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                ForEach(filteredNotes) { note in
                    NavigationLink(destination: NoteEditor(note: note)) {
                        NoteRow(note: note)
                    }
                    .swipeActions(edge: .trailing) {
                        Button { store.togglePin(note) } label: { Label(note.pinned ? "Unpin" : "Pin", systemImage: note.pinned ? "pin.slash" : "pin") }
                            .tint(.yellow)
                        Button(role: .destructive) { store.delete(note) } label: { Label("Delete", systemImage: "trash") }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SmartNotes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingNewNote = true } label: { Image(systemName: "square.and.pencil") }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteEditor(note: Note(title: "", body: ""))
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))

            Text("Select a note or create a new one")
                .foregroundStyle(.secondary)
        }
    }

    var uniqueTags: [String] {
        let tags = store.notes.flatMap { $0.tags }
        return Array(Set(tags)).sorted()
    }
}

// MARK: - Tag Chip

struct TagChip: View {
    var tag: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Note Row

struct NoteRow: View {
    var note: Note

    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: note.colorHex) ?? Color.gray.opacity(0.2))
                .frame(width: 8)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                    Spacer()
                    if note.pinned { Image(systemName: "pin.fill").foregroundColor(.yellow) }
                }

                Text(note.body.trimmingCharacters(in: .whitespacesAndNewlines))
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    ForEach(note.tags.prefix(3), id: \.(self)) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .padding(4)
                            .background(Color(.systemGray5))
                            .cornerRadius(6)
                    }
                    Spacer()
                    Text(note.updatedAt, style: .date)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

