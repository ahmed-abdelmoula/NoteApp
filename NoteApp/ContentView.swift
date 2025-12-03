import SwiftUI

struct ContentView: View {
    // We hold our list of notes here
    @State private var notes: [Note] = Note.sampleData

    var body: some View {
        NavigationStack {
            List(notes) { note in
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.headline)
                    Text(note.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1) // Keep list clean
                    Text(note.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("QuickNotes")
            .toolbar {
                Button(action: {
                    print("Add note tapped")
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
