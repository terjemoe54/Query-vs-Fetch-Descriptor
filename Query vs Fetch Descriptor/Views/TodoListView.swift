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
    
    
    
    private var sortedTodoes: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            showCompletedOnly ? completedTitleTodos : titleTodos
        case .byDate:
            showCompletedOnly ? completedDateTodos : dateTodos
        }
    }
    
    // Today todos
    static var todayFetchDescriptor: FetchDescriptor<TodoModel> {
        let now = Date()
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now)!
        
        let descriptor = FetchDescriptor<TodoModel>(
            predicate: #Predicate { $0.date >= beginningOfDay && $0.date <= endOfDay },sortBy: [SortDescriptor(\.date)])
        
        return descriptor
    }
    @Query(TodoListView.todayFetchDescriptor)
    private var todaysDaysTodo: [TodoModel]
    
    @State private var showTodaysTodos: Bool = false
    
    // Tags
    @State private var selectedTags: Set<Tag> = []
    @State private var tagCount = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack  {
                    // Text Field
                    InputView(newTitle: $newTitle) {
                        addTodo()
                    }
                    // Date Picker
                    SelectDateView(selectedDate: $selectedDate)
                    
                    //Tag selection
                    TagSelectionView(action: { tag in
                        toggleTag(tag)
                    }, selectedTags: selectedTags)
                    
                    // Segmented picker
                    SegmentPickerView(selectedSortOption: $selectedSortOption)
                    
                    // Toggle completion
                    ToggleViews(showCompletedOnly: $showCompletedOnly, showTodaysTodos: $showTodaysTodos)
                }
                .padding()
                
                // List
                //            List(sevenDaysTodo) { todo in
                List(showTodaysTodos ? todaysDaysTodo : sortedTodoes) { todo in
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
                        VStack(alignment: .trailing) {
                            VStack(alignment: .leading) {
                                Text(todo.date, style: .date)
                                Text(todo.date, style: .time)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                let tagsSorted = todo.tags?.sorted(by: { $0.rawValue < $1.rawValue})
                                
                                ForEach(tagsSorted ?? [], id: \.self) { tag in
                                    Text(tag.rawValue.capitalized)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(tag.color)
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                        .clipShape(Capsule())
                                    
                                }
                            }
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
        let newTodo = TodoModel(title: newTitle, date: selectedDate, tags: selectedTags)
        modelContext.insert(newTodo)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save the new todo: \(error.localizedDescription)")
        }
        newTitle = ""
        selectedDate = Date()
        selectedTags = []
        tagCount = 0
    }
    
    private func deleteTodo(_ todo: TodoModel) {
        modelContext.delete(todo)
        try? modelContext.save()
    }
    
    private func toggleComletion(_ todo: TodoModel) {
        todo.isCompleted.toggle()
        try? modelContext.save()
    }
    
    private func toggleTag(_ tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
            tagCount -= 1
        } else {
            if tagCount < 3 {
                selectedTags.insert(tag)
                tagCount += 1
            }
        }
    }
}



#Preview {
    TodoListView()
        .modelContainer(for: TodoModel.self)
}
