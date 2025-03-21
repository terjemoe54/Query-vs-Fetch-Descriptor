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
    
    // Completed todos for date
    @Query(
        filter: #Predicate<TodoModel> { $0.isCompleted == true },
        sort: [SortDescriptor(\TodoModel.date)])
    var completedDateTodos: [TodoModel]
                             
    // Completed todos for title
    @Query(
        filter: #Predicate<TodoModel> { $0.isCompleted == true },
        sort: [SortDescriptor(\TodoModel.title)])
    var completedTitleTodos: [TodoModel]
    
    @State private var showCompletedOnly: Bool = false
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
            showCompletedOnly ? completedTitleTodos : titleTodos
        case .byDate:
            showCompletedOnly ? completedDateTodos : dateTodos
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
                    // Toggle Completion
                    Toggle("Show Completed Only", isOn: $showCompletedOnly)
                }
                .padding()
                
                // List
                List(sortedTodoes) { todo in
                    HStack {
                        Button {
                            toggleComletion(todo)
                        } label: {
                            Image(systemName: todo.isCompleted ? "checkmark.circle" : "circle")
                                .font(.caption)
                                .foregroundStyle(todo.isCompleted ? .green : .gray)
                        }
                        Text(todo.title)
                            .foregroundStyle(todo.isCompleted ? .gray : .blue)
                            .strikethrough(todo.isCompleted, color: .gray)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(todo.date, style: .date)
                            Text(todo.date, style: .time)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteTodo(todo)
                        } label: {
                            Label("Delete", systemImage: "trash")
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
        let newTodo = TodoModel(title: newTitle, date: selectedDate
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
        modelContext.delete(todo)
        try? modelContext.save()
    }
    
    private func toggleComletion(_ todo: TodoModel) {
        todo.isCompleted.toggle()
        try? modelContext.save()
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoModel.self)
}
