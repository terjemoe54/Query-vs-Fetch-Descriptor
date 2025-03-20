//
//  ContentView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 20/03/2025.
//




import SwiftUI
import SwiftData

struct TodoListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TodoModel.date)]) var dateTodos: [TodoModel]
    @Query(sort: [SortDescriptor(\TodoModel.title)]) var titleTodos: [TodoModel]
    
    @State private var newTitle: String = ""
    @State private var selectedSortOption: SortOption = .byTitle
    @State private var selectedDate: Date = Date()
    
    enum SortOption: String, CaseIterable {
        case byTitle = "By Title"
        case byDate = "By Date"
    }
    
    private var sortedTodoes: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            return titleTodos
        case .byDate:
            return dateTodos
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack  {
                    // Text Field
                    HStack {
                        TextField("New Todo", text: $newTitle)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            addTodo()
                        } label: {
                            Text("Add")
                                .padding()
                                .background(.blue)
                                .clipShape(.rect(cornerRadius: 10))
                                .foregroundStyle(.white)
                        }

                    }
                   // Date Picker
                    DatePicker("Select Date",
                               selection: $selectedDate,
                               in: Date()...
                    )
                   // Segmented picker
                    Picker(
                        "Sort Todoes",
                        selection: $selectedSortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
            
                // List
                List(sortedTodoes) { todo in
                    HStack {
                        Text(todo.title)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(todo.date, style: .date)
                            Text(todo.date, style: .time)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }.listStyle(PlainListStyle())
            }
            .navigationTitle("Todoes")
        }
    }
    
        
    private func addTodo() {
        guard newTitle.count >= 2 else {
            print("The title must have at least two elements")
            return
        }
        let newTodo = TodoModel(title: newTitle,
                                date: selectedDate
        )
        modelContext.insert(newTodo)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save the new todo: \(error.localizedDescription)")
            
        }
        
        newTitle = ""
        selectedDate = Date()
    }
    
    private func deleteTodo(_ todo: TodoModel) {
        
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoModel.self)
}
